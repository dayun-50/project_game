class Game4WinScene extends Phaser.Scene {
  constructor() {
    super("Game4WinScene");
  }

  init(data) {
    this.finalScore = data.score || 0;
    this.resultText = data.result || "YOU WIN";
  }

  create() {
    const { width, height } = this.cameras.main;
	
	
    // === YOU WIN 크게 금색 ===
    this.add.text(width / 2, height / 2 - 150, "YOU WIN!", {
      fontSize: "80px",
      color: "#FFD700",
      fontStyle: "bold",
      stroke: "#000000",
      strokeThickness: 8
    }).setOrigin(0.5);

    // === 점수 표시 ===
    this.add.text(width / 2, height / 2 - 40, `최종 점수: ${this.finalScore}`, {
      fontSize: "40px",
      color: "#ffffff",
      stroke: "#000000",
      strokeThickness: 6
    }).setOrigin(0.5);

    // === 다시하기 버튼 ===
    const retryText = this.add.text(width / 2, height / 2 + 100, "다시하기", {
      fontSize: "36px",
      color: "#00ff00",
      backgroundColor: "#000000",
      padding: { x: 20, y: 10 }
    }).setOrigin(0.5).setInteractive();

    retryText.on("pointerdown", () => {
      this.scene.start("TitleScene"); // ⚠️ 여기서도 MainScene 이름 맞춰주세요
    });
  }
}
