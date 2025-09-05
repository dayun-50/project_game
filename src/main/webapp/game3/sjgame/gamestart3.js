class gamestart3 extends Phaser.Scene {
    constructor() {
        super('gamestart3');
    }

    create() {
        // START 버튼 생성
        const startText = this.add.text(
            this.scale.width / 2,
            this.scale.height / 2,
            'START',
            {
                font: '64px Arial',
                fill: '#ffffff',
                backgroundColor: '#0000ff',
                padding: { x: 30, y: 15 },
            }
        ).setOrigin(0.5).setInteractive();

        // Hover 효과
        startText.on('pointerover', () => {
            startText.setStyle({ fill: '#ffeb3b', backgroundColor: '#ff5722' });
            this.tweens.add({ targets: startText, scale: 1.2, duration: 200, ease: 'Power2' });
        });

        startText.on('pointerout', () => {
            startText.setStyle({ fill: '#ffffff', backgroundColor: '#0000ff' });
            this.tweens.add({ targets: startText, scale: 1, duration: 200, ease: 'Power2' });
        });

        // 클릭 시 Gameplay 씬 시작
        startText.on('pointerdown', () => {
            this.scene.start('game3play');
        });

        // 화면 리사이즈 이벤트 처리
        this.scale.on('resize', (gameSize) => {
            startText.setPosition(gameSize.width / 2, gameSize.height / 2);
        });
    }
}
