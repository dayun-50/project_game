class TitleScene extends Phaser.Scene {
  constructor() {
    super("TitleScene");
  }

  preload() {
    this.load.setBaseURL("/game4");

    this.load.image("naverImg", "asset/kmaple.png");
    this.load.image("bg", "asset/bg.png");
  }

  create() {
    const { width, height } = this.scale;

    // === 배경 ===
    this.add.image(width / 2, height / 2, "bg")
      .setDisplaySize(width, height)
      .setOrigin(0.5)
      .setScrollFactor(0);

    // === 로고 ===
    this.add.sprite(width / 2, 200, "naverImg")
      .setScale(0.5)
      .setScrollFactor(0);

    // === PRESS R TO START ===
    const press = this.add.text(width / 2, height - 80, "PRESS  R  TO  START", {
      fontFamily: "monospace",
      fontSize: "15px",
      resolution: 2,
      color: "#fff",
      stroke: "#000",
      strokeThickness: 4,
    })
      .setOrigin(0.5)
      .setScrollFactor(0);

    this.tweens.add({
      targets: press,
      alpha: { from: 1, to: 0.15 },
      duration: 600,
      yoyo: true,
      repeat: -1,
    });

    // === 시작 함수 ===
    const startGame = () => {
      console.log("▶ TitleScene → JobScene 이동");

      // 🔑 입력 이벤트 정리 (중복 방지)
      this.input.keyboard.removeAllListeners();
      this.input.removeAllListeners();

      this.cameras.main.fadeOut(1000, 0, 0, 0);
      this.cameras.main.once("camerafadeoutcomplete", () => {
        this.scene.start("JobScene"); // ✅ 항상 JobScene부터 시작
        this.cameras.main.fadeIn(1000, 0, 0, 0);
      });
    };

    // === 키보드 입력 ===
    this.input.keyboard.on("keydown-R", startGame);
    this.input.keyboard.on("keydown-ENTER", startGame);

    // === 씬 종료 시 이벤트 제거 ===
    this.events.on("shutdown", () => {
      this.input.keyboard.removeAllListeners();
      this.input.removeAllListeners();
    });
  }
}
