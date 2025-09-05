class Game2OverScene extends Phaser.Scene {
  constructor() {
    super('Game2OverScene');
  }

  // GameScene에서 전달한 데이터를 받음
  init(data) {
    this.finalScore = data.score || 0;
  }

  preload() {
    // 배경 이미지 불러오기
    this.load.image('gameOverBg', '/game2/asset/게임오버.png');
  }

  create() {
    const { width, height } = this.cameras.main;

    // === 배경 추가 ===
    const bg = this.add.image(width / 2, height / 2, 'gameOverBg')
      .setOrigin(0.5, 0.5);

    // 화면에 맞게 스케일 조정
    const scaleX = width / bg.width;
    const scaleY = height / bg.height;
    const scale = Math.max(scaleX, scaleY); // 배경이 화면 꽉 차도록
    bg.setScale(scale);

    // Game Over 텍스트
    this.add.text(width / 2, height / 2 - 100, 'GAME OVER', {
      fontSize: '64px',
      fontFamily: 'monospace',
      color: '#ff0000',
      stroke: '#000',
      strokeThickness: 6
    }).setOrigin(0.5);

    // 최종 점수 출력
    this.add.text(width / 2, height / 2, `SCORE : ${this.finalScore}`, {
      fontSize: '32px',
      fontFamily: 'monospace',
      color: '#ffff00',
      stroke: '#000',
      strokeThickness: 4
    }).setOrigin(0.5);

    // 다시하기 버튼
    const retry = this.add.text(width / 2, height / 2 + 100, 'RETRY', {
      fontSize: '32px',
      fontFamily: 'monospace',
      color: '#ffffff',
      backgroundColor: '#000',
      padding: { x: 20, y: 10 }
    }).setOrigin(0.5).setInteractive();

    retry.on('pointerdown', () => {
      this.scene.start('Game2Scene'); // GameScene으로 돌아가기
    });
  }
}
