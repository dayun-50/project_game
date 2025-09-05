class Exam04 extends Phaser.Scene {
    constructor() {
        super("Exam04");
    }

    init(data) {
        // Gameplay에서 전달받은 최종 시간
        this.finalTime = data.finalTime || "0.00";
    }

    create() {
        const canvasWidth = this.sys.game.config.width;
        const canvasHeight = this.sys.game.config.height;

        // 배경
        this.add.rectangle(0, 0, canvasWidth, canvasHeight, 0x000000).setOrigin(0, 0);

        // Game Over 텍스트
        this.add.text(canvasWidth / 2, canvasHeight / 2 - 100, "GAME OVER", {
            font: "64px Arial",
            fill: "#b968ffff"
        }).setOrigin(0.5);

        // 최종 시간 표시
        this.add.text(canvasWidth / 2, canvasHeight / 2 - 20, `Time: ${this.finalTime} 초`, {
            font: "32px Arial",
            fill: "#ffffff"
        }).setOrigin(0.5);
		
		
		
        // 다시 시작 버튼
        const restartText = this.add.text(canvasWidth / 2, canvasHeight / 2 + 100, "다시 시작", {
            font: "48px Arial",
            fill: "yellow",
            backgroundColor: "skyblue",
            padding: { x: 20, y: 10 }
        }).setOrigin(0.5).setInteractive();

        restartText.on('pointerover', () => restartText.setStyle({ fill: "#ffeb3b", backgroundColor: "green" }));
        restartText.on('pointerout', () => restartText.setStyle({ fill: "orange", backgroundColor: "skyblue" }));

        restartText.on('pointerdown', () => {
            this.scene.stop("Exam04"); // 기존 Gameplay 씬 종료
            this.scene.start("Exam03"); // 새로 시작
        });
    }
}
