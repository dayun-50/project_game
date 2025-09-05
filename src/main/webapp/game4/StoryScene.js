class StoryScene extends Phaser.Scene {
  constructor(){ super('StoryScene'); }

  init(data) {
    this.selectedJob = data.job;  
    console.log("선택된 직업:", this.selectedJob);
    this.storyStep = 0; // 스토리 단계
  }

  preload() {
    this.load.setBaseURL("/game4");
    this.load.image('warriorImg', 'asset/전사스토리.png');
    this.load.image('warriorImg2','asset/전사스토리2.png');
    this.load.image('warriorImg3','asset/전사스토리3.png');
  }

  create() {
    console.log("✅ StoryScene create 실행됨");

    if (this.selectedJob === "warrior") {
      this.bgImage = this.add.image(
        this.cameras.main.centerX,
        this.cameras.main.centerY,
        "warriorImg"
      ).setDisplaySize(this.scale.width, this.scale.height); // 🚀 여백 없이 꽉 채우기

      this.storyText = this.add.text(
        this.cameras.main.centerX,
        this.scale.height - 80,
        "수많은 전사들이 그를 물리치고자 모든 힘을 쏟아부었지만",
        {
          fontFamily: "Arial",
          fontSize: "32px",
          color: "red",
          align: "center"
        }
      ).setOrigin(0.5).setAlpha(0);

      this.tweens.add({
        targets: this.storyText,
        alpha: 1,
        duration: 2000,
        ease: "Power2"
      });
    }

    // 🚀 입력 이벤트 확인 로그
    this.input.on("pointerdown", () => {
      console.log("✅ CLICK detected");
      this.nextStory();
    });

    // 🚀 키보드 SPACE 추가
    this.spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
    this.game.canvas.setAttribute("tabindex", "0");
    this.game.canvas.focus();
  }

  update() {
    if (Phaser.Input.Keyboard.JustDown(this.spaceKey)) {
      console.log("✅ SPACE detected");
      this.nextStory();
    }
  }

  nextStory() {
    this.storyStep++;
    console.log("➡️ nextStory 실행됨, 현재 단계:", this.storyStep);

    if (this.storyStep === 1) {
      this.bgImage.setTexture("warriorImg2")
                  .setDisplaySize(this.scale.width, this.scale.height);
      this.storyText.setText("그러나 어둠의 힘은 너무나 강력했다...");
    } else if (this.storyStep === 2) {
      this.bgImage.setTexture("warriorImg3")
                  .setDisplaySize(this.scale.width, this.scale.height);
      this.storyText.setText("과연 당신은 마지막까지 생존할 수 있을까?");
    } else {
      console.log("➡️ GameScene으로 이동");
      this.scene.start('Game4Scene', { job: this.selectedJob });
    }
  }
}
