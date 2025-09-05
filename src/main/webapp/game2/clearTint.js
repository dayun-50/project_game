// clearTint.js
// 전역에 ClearTint 클래스를 노출합니다. (export 사용 X)
window.ClearTint = class ClearTint extends Phaser.Scene {
  constructor() {
    super('ClearScene');
  }

  // GameScene에서 { score, nextScene }를 넘겨줄 수 있음
  init(data) {
    this.finalScore = data?.score ?? 0;
    this.nextSceneKey = data?.nextScene || 'GameScene'; 
    this.nextSceneData = { score: this.finalScore, from: 'ClearScene' };
  }

  preload() {
    // 프로젝트 경로에 맞게 수정하세요. 예: asset/클리어.png
    // 이미 어딘가에서 로드되어 있다면 중복 로드는 생략 가능.
    if (!this.textures.exists('clear_bg')) {
      this.load.image('clear_bg', 'asset/클리어.png');
    }
  }

  create() {
    const cam = this.cameras.main;
    const { width, height } = cam;

    // 배경
    const bg = this.add.image(width / 2, height / 2, 'clear_bg')
      .setOrigin(0.5)
      .setScrollFactor(0);

    // contain 스케일(잘림 방지)
    const scaleX = width / bg.width;
    const scaleY = height / bg.height;
    bg.setScale(Math.min(scaleX, scaleY));

    // 화이트 플래시 연출
    const flash = this.add.rectangle(0, 0, width * 2, height * 2, 0xffffff, 1)
      .setOrigin(0);
    this.tweens.add({
      targets: flash,
      alpha: { from: 1, to: 0 },
      duration: 450,
      ease: 'Quad.easeOut',
      onComplete: () => flash.destroy(),
    });

    this.add.text(width / 2, height / 2 - 120, 'STAGE CLEAR!', {
      fontSize: '64px',
      fontFamily: 'monospace',
      color: '#00ff99',
      stroke: '#000',
      strokeThickness: 6,
    }).setOrigin(0.5);

    this.add.text(width / 2, height / 2 - 40, `SCORE : ${this.finalScore}`, {
      fontSize: '36px',
      fontFamily: 'monospace',
      color: '#ffff00',
      stroke: '#000',
      strokeThickness: 4,
    }).setOrigin(0.5);

    this.add.text(width / 2, height / 2 + 60, 'PRESS SPACE OR TAP TO CONTINUE', {
      fontSize: '20px',
      fontFamily: 'monospace',
      color: '#ffffff',
      stroke: '#000',
      strokeThickness: 3,
    }).setOrigin(0.5);

   
    this.input.once('pointerdown', () => this._goNext());

    // 선택 버튼들(옵션)
    const yBase = height / 2 + 120;
      this._makeButton(width / 2, yBase, 'RETRY', () => {
      this.scene.start('GameScene', { score: 0, from: 'ClearScene:retry' });
    });
    
  }

  _goNext() {
    this.scene.start(this.nextSceneKey, this.nextSceneData);
  }

  _makeButton(x, y, label, onClick) {
    const txt = this.add.text(x, y, label, {
      fontSize: '24px',
      fontFamily: 'monospace',
      color: '#ffffff',
      backgroundColor: '#000',
      padding: { x: 14, y: 8 },
    }).setOrigin(0.5).setInteractive({ useHandCursor: true });

    txt.on('pointerover', () => txt.setStyle({ backgroundColor: '#222' }));
    txt.on('pointerout',  () => txt.setStyle({ backgroundColor: '#000' }));
    txt.on('pointerdown', onClick);
    return txt;
  }
};
