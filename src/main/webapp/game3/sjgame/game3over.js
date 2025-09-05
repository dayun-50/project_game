class game3over extends Phaser.Scene {
    constructor() {
        super("game3over");
    }

    init(data) {
        this.finalTime = data.finalTime || "0.00";
    }

    create() {
        // 화면 크기 기준 변수
        let canvasWidth = this.scale.width;
        let canvasHeight = this.scale.height;

        // 배경
        this.bg = this.add.rectangle(0, 0, canvasWidth, canvasHeight, 0x000000).setOrigin(0, 0);

        // Game Over 텍스트
        this.gameOverText = this.add.text(canvasWidth / 2, canvasHeight / 2 - 100, "GAME OVER", {
            font: "64px Arial",
            fill: "#ff0000"
        }).setOrigin(0.5);

        // 최종 시간 표시
        this.timeText = this.add.text(canvasWidth / 2, canvasHeight / 2 - 20, `Time: ${this.finalTime} 초`, {
            font: "32px Arial",
            fill: "#ffffff"
        }).setOrigin(0.5);

        // 다시 시작 버튼
        this.restartText = this.add.text(canvasWidth / 2, canvasHeight / 2 + 100, "다시 시작", {
            font: "48px Arial",
            fill: "#ffffff",
            backgroundColor: "#0000ff",
            padding: { x: 20, y: 10 }
        }).setOrigin(0.5).setInteractive();

        this.restartText.on('pointerover', () => this.restartText.setStyle({ fill: "#ffeb3b", backgroundColor: "#ff5722" }));
        this.restartText.on('pointerout', () => this.restartText.setStyle({ fill: "#ffffff", backgroundColor: "#0000ff" }));
        this.restartText.on('pointerdown', () => {
            this.scene.stop("game3play");
            this.scene.start("game3play");
        });

        // 화면 리사이즈 이벤트
        this.scale.on('resize', (gameSize) => {
            canvasWidth = gameSize.width;
            canvasHeight = gameSize.height;

            this.bg.setSize(canvasWidth, canvasHeight);
            this.gameOverText.setPosition(canvasWidth / 2, canvasHeight / 2 - 100);
            this.timeText.setPosition(canvasWidth / 2, canvasHeight / 2 - 20);
            this.restartText.setPosition(canvasWidth / 2, canvasHeight / 2 + 100);
        });
    }
}
