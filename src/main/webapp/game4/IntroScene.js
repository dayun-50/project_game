class IntroScene extends Phaser.Scene {
  constructor() {
    super("IntroScene");
  }

  init(data) {
    this.selectedJob = data.job;
    console.log("IntroScene에서 받은 job:", this.selectedJob);
  }

  create() {
    this.cameras.main.setBackgroundColor("#000000");

    const textContent = "깊은 어둠 속에서... 강대한 힘이 깨어났다.";

    // 임시 텍스트 만들고 폭 계산
    let tmpText = this.add.text(0, 0, textContent, {
      fontFamily: "Arial",
      fontSize: "32px",
      color: "#ffffff"
    }).setAlpha(0); // 보이지 않게
    const textWidth = tmpText.width;
    tmpText.destroy();

    // === 중앙 배치 ===
    let storyText = this.add.text(
      this.cameras.main.centerX - textWidth / 2,  // 🚀 직접 중앙 정렬
      this.cameras.main.centerY,
      textContent,
      {
        fontFamily: "Arial",
        fontSize: "32px",
        color: "#ffffff"
      }
    ).setAlpha(0);

    this.tweens.add({
      targets: storyText,
      alpha: 1,
      duration: 2000,
      ease: "Power2"
    });

    const goStory = () => {
      console.log("StoryScene으로 이동, job:", this.selectedJob);
      this.scene.start("StoryScene", { job: this.selectedJob });
    };

    this.input.keyboard.on("keydown-SPACE", goStory);
    this.input.on("pointerdown", goStory);
  }
}
