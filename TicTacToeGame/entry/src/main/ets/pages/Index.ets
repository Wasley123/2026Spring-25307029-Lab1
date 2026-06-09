// 棋子类型枚举
enum Player {
  None = 0,
  Player1 = 1,  // X
  Player2 = 2   // O
}

// 棋子数据结构
interface CellData {
  player: Player
  timestamp: number
  remainingTime: number
}

@Entry
@Component
struct Index {
  @State board: CellData[][] = this.initBoard()
  @State currentPlayer: Player = Player.Player1
  @State gameOver: boolean = false
  @State winner: Player = Player.None
  @State player1Score: number = 0
  @State player2Score: number = 0
  
  private timer: number = -1
  
  aboutToAppear() {
    this.timer = setInterval(() => {
      this.updateBoard()
    }, 1000)
  }
  
  aboutToDisappear() {
    if (this.timer !== -1) {
      clearInterval(this.timer)
    }
  }
  
  private initBoard(): CellData[][] {
    const board: CellData[][] = []
    for (let i = 0; i < 3; i++) {
      board[i] = []
      for (let j = 0; j < 3; j++) {
        board[i][j] = {
          player: Player.None,
          timestamp: 0,
          remainingTime: 0
        }
      }
    }
    return board
  }
  
  private updateBoard() {
    if (this.gameOver) return
    
    const now = Date.now()
    let changed = false
    
    // 创建新的数组来触发UI更新
    let newBoard: CellData[][] = []
    for (let i = 0; i < 3; i++) {
      newBoard[i] = []
      for (let j = 0; j < 3; j++) {
        if (this.board[i][j].player !== Player.None) {
          const elapsed = Math.floor((now - this.board[i][j].timestamp) / 1000)
          const remaining = 2 - elapsed
          
          if (remaining <= 0) {
            newBoard[i][j] = {
              player: Player.None,
              timestamp: 0,
              remainingTime: 0
            }
            changed = true
          } else {
            newBoard[i][j] = {
              player: this.board[i][j].player,
              timestamp: this.board[i][j].timestamp,
              remainingTime: remaining
            }
          }
        } else {
          newBoard[i][j] = this.board[i][j]
        }
      }
    }
    
    this.board = newBoard
    
    if (changed) {
      this.checkWinner()
    }
  }
  
  private handleCellClick(row: number, col: number) {
    if (this.gameOver) return
    if (this.board[row][col].player !== Player.None) return
    
    // 创建新的数组来触发UI更新
    let newBoard: CellData[][] = []
    for (let i = 0; i < 3; i++) {
      newBoard[i] = []
      for (let j = 0; j < 3; j++) {
        if (i === row && j === col) {
          newBoard[i][j] = {
            player: this.currentPlayer,
            timestamp: Date.now(),
            remainingTime: 2
          }
        } else {
          newBoard[i][j] = this.board[i][j]
        }
      }
    }
    this.board = newBoard
    
    if (this.checkWinner()) {
      return
    }
    
    this.currentPlayer = this.currentPlayer === Player.Player1 ? Player.Player2 : Player.Player1
  }
  
  private checkWinner(): boolean {
    // 检查行
    for (let i = 0; i < 3; i++) {
      if (this.board[i][0].player !== Player.None &&
          this.board[i][0].player === this.board[i][1].player &&
          this.board[i][1].player === this.board[i][2].player) {
        this.setWinner(this.board[i][0].player)
        return true
      }
    }
    
    // 检查列
    for (let j = 0; j < 3; j++) {
      if (this.board[0][j].player !== Player.None &&
          this.board[0][j].player === this.board[1][j].player &&
          this.board[1][j].player === this.board[2][j].player) {
        this.setWinner(this.board[0][j].player)
        return true
      }
    }
    
    // 检查对角线
    if (this.board[0][0].player !== Player.None &&
        this.board[0][0].player === this.board[1][1].player &&
        this.board[1][1].player === this.board[2][2].player) {
      this.setWinner(this.board[0][0].player)
      return true
    }
    
    if (this.board[0][2].player !== Player.None &&
        this.board[0][2].player === this.board[1][1].player &&
        this.board[1][1].player === this.board[2][0].player) {
      this.setWinner(this.board[0][2].player)
      return true
    }
    
    // 检查平局
    let full = true
    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        if (this.board[i][j].player === Player.None) {
          full = false
          break
        }
      }
    }
    
    if (full) {
      this.gameOver = true
      return true
    }
    
    return false
  }
  
  private setWinner(player: Player) {
    this.winner = player
    this.gameOver = true
    if (player === Player.Player1) {
      this.player1Score++
    } else {
      this.player2Score++
    }
  }
  
  private restartGame() {
    this.board = this.initBoard()
    this.currentPlayer = Player.Player1
    this.gameOver = false
    this.winner = Player.None
  }
  
  private getCellText(cell: CellData): string {
    if (cell.player === Player.Player1) return 'X'
    if (cell.player === Player.Player2) return 'O'
    return ''
  }
  
  private getCellColor(player: Player): string {
    if (player === Player.Player1) return '#FF6B6B'
    if (player === Player.Player2) return '#4ECDC4'
    return '#E0E0E0'
  }
  
  build() {
    Column() {
      // 标题
      Text('双人井字棋')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({ top: 40, bottom: 10 })
      
      Text('棋子会在2秒后消失')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 20 })
      
      // 分数显示
      Row() {
        Column() {
          Text('玩家1 (X)')
            .fontSize(16)
            .fontColor('#FF6B6B')
          Text(`${this.player1Score}`)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FF6B6B')
        }
        .layoutWeight(1)
        
        Column() {
          Text('玩家2 (O)')
            .fontSize(16)
            .fontColor('#4ECDC4')
          Text(`${this.player2Score}`)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#4ECDC4')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .margin({ bottom: 20 })
      
      // 当前玩家提示
      if (!this.gameOver) {
        Text(`当前: 玩家${this.currentPlayer === Player.Player1 ? '1 (X)' : '2 (O)'}`)
          .fontSize(18)
          .fontColor(this.getCellColor(this.currentPlayer))
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 20 })
      }
      
      // 游戏结果
      if (this.gameOver) {
        Text(this.winner === Player.None ? '平局！' : `玩家${this.winner === Player.Player1 ? '1' : '2'} 获胜！`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.winner === Player.None ? '#666666' : this.getCellColor(this.winner))
          .margin({ bottom: 20 })
      }
      
      // 棋盘
      Column() {
        ForEach([0, 1, 2], (row: number) => {
          Row() {
            ForEach([0, 1, 2], (col: number) => {
              Column() {
                Stack({ alignContent: Alignment.Center }) {
                  // 背景格子
                  Column()
                    .width(90)
                    .height(90)
                    .backgroundColor('#FFFFFF')
                    .borderRadius(8)
                    .shadow({ radius: 4, color: '#00000020', offsetX: 0, offsetY: 2 })
                  
                  // 棋子
                  if (this.board[row][col].player !== Player.None) {
                    Column() {
                      Text(this.getCellText(this.board[row][col]))
                        .fontSize(48)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(this.getCellColor(this.board[row][col].player))
                      
                      Text(`${this.board[row][col].remainingTime}s`)
                        .fontSize(14)
                        .fontColor('#999999')
                        .margin({ top: 2 })
                    }
                    .width(90)
                    .height(90)
                    .justifyContent(FlexAlign.Center)
                  }
                }
                .width(90)
                .height(90)
                .onClick(() => this.handleCellClick(row, col))
              }
              .margin(5)
            })
          }
        })
      }
      .padding(10)
      .backgroundColor('#E8E8E8')
      .borderRadius(12)
      
      // 重新开始按钮
      Button(this.gameOver ? '再来一局' : '重新开始')
        .width(200)
        .height(50)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#6C5CE7')
        .borderRadius(25)
        .margin({ top: 30 })
        .onClick(() => this.restartGame())
      
      // 游戏说明
      Column() {
        Text('游戏规则')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })
        
        Text('• 双方轮流在棋盘上放置棋子')
          .fontSize(14)
          .fontColor('#666666')
        
        Text('• 棋子会在放置2秒后消失')
          .fontSize(14)
          .fontColor('#666666')
        
        Text('• 先连成一条线者获胜')
          .fontSize(14)
          .fontColor('#666666')
      }
      .margin({ top: 30 })
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 40, right: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
