class TitleScene2 extends Phaser.Scene {
  constructor() {
    super('TitleScene2');
  }

  preload() {
    // 배경 이미지 불러오기
    this.load.image('titleBg', '/game2/asset/인서트.png');
  }

  create() {
    const cam = this.cameras.main;
    const bg = this.add.image(cam.width / 2, cam.height / 2, 'titleBg')
      .setOrigin(0.5, 0.5)
      .setScrollFactor(0);

    // 화면 크기에 맞게 스케일 조정
    const scaleX = cam.width / bg.width;
    const scaleY = cam.height / bg.height;
    const scale = Math.min(scaleX, scaleY);
    bg.setScale(scale);

    // PRESS R TO START 텍스트
    const press = this.add.text(550, 720, 'PRESS  R  TO  START', {
      fontFamily: 'monospace',
      fontSize: '28px',
      color: '#fff',
      stroke: '#000',
      strokeThickness: 6
    }).setOrigin(0.5);

    this.tweens.add({
      targets: press,
      alpha: { from: 1, to: 0.15 },
      duration: 600,
      yoyo: true,
      repeat: -1
    });

    // R 키 입력 → Game2Scene 이동
    this.input.keyboard.on('keydown-R', () => {
      cam.fadeOut(1000, 0, 0, 0);
      cam.once('camerafadeoutcomplete', () => this.scene.start('Game2Scene'));
    });
  }
}

// ⚡ GameStart2.jsp 또는 다른 JS에서 config에 추가할 때:
const config = {
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  backgroundColor: '#000000',
  physics: {
    default: 'arcade',
    arcade: { debug: true }
  },
  scene: [TitleScene2, Game2Scene, Game2OverScene, ClearTint]
};

// 전역에서 game2 인스턴스를 관리하도록
if (!window.game2) {
  window.game2 = new Phaser.Game(config);
}
