class Game4OverScene extends Phaser.Scene {
  constructor() {
    super("Game4OverScene");
  }

  init(data) {
    this.score = data.score || 0;

  }

  create() {
    const { width, height } = this.scale;
	
	

	
    // === GAME OVER 텍스트 ===
    this.add.text(width / 2, height / 3, "GAME OVER", {
      fontSize: "96px",
      color: "#ff0000",
      fontStyle: "bold",
      stroke: "#000000",
      strokeThickness: 8
    }).setOrigin(0.5);

    // === 결과 메시지 (YOU WIN / YOU DIED) ===
    this.add.text(width / 2, height / 2 - 50, this.result, {
      fontSize: "48px",
      color: "#ff0000",
      fontStyle: "bold"
    }).setOrigin(0.5);

    // === 점수 표시 ===
    this.add.text(width / 2, height / 2 + 20, `이번 판 최종 점수: ${this.score}`, {
      fontSize: "40px",
      color: "#ffff00",
      fontStyle: "bold"
    }).setOrigin(0.5);

    // === 다시하기 버튼 ===
    const retryText = this.add.text(width / 2, height / 2 + 120, "다시하기", {
      fontSize: "36px",
      color: "#00ff00",
      backgroundColor: "#000000",
      padding: { x: 20, y: 10 }
    }).setOrigin(0.5).setInteractive();

    retryText.on("pointerover", () => retryText.setStyle({ color: "#ffffff" }));
    retryText.on("pointerout", () => retryText.setStyle({ color: "#00ff00" }));
    retryText.on("pointerdown", () => {
      this.scene.start("TitleScene"); // 🔥 MainScene으로 이동
    });
  }
}