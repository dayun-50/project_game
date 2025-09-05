class JobScene extends Phaser.Scene {
  constructor() {
    super("JobScene");
  }

  preload() {
    this.load.setBaseURL("/game4");
    this.load.image("warrior", "asset/전사.png");
    this.load.image("mage", "asset/마법사.png");
    this.load.image("bg", "asset/배경.png");
    this.load.image("panel", "asset/패널.png");
  }

  create() {
    const screen = document.getElementById("screen");
    const rect = screen.getBoundingClientRect();

    const centerX = this.cameras.main.centerX;
    const centerY = this.cameras.main.centerY;

    // === 배경 ===
    let bg = this.add.image(centerX, centerY, "bg");
    let scaleX = rect.width / bg.width;
    let scaleY = rect.height / bg.height;
    let scale = Math.min(scaleX, scaleY);
    bg.setScale(scale).setOrigin(0.5);

    // === 안내 텍스트 ===
    this.add.text(centerX, rect.height * 0.12, "당신의 직업을 선택해 주세요", {
      fontFamily: "monospace",
      fontSize: `${Math.floor(rect.height / 26)}px`, // 조금 더 작게
      stroke: "#000",
      strokeThickness: 4,
      resolution: 8    // ✅ 더 선명하게
    }).setOrigin(0.5);

    // === 캐릭터 ===
    let warriorTween, mageTween;

    // 캐릭터 크기 줄임
    const charWidth = 100;
    const charHeight = 140;

    const warrior = this.add.image(centerX - rect.width * 0.18, centerY, "warrior")
      .setInteractive()
      .setDisplaySize(charWidth, charHeight)
      .setOrigin(0.5, 1); // 발바닥 기준

    const mage = this.add.image(centerX + rect.width * 0.18, centerY, "mage")
      .setInteractive()
      .setDisplaySize(charWidth, charHeight)
      .setOrigin(0.5, 1);

    // === 패널 ===
    const panel = this.add.image(centerX, rect.height + 200, "panel")
      .setOrigin(0.5, 0.5)
      .setVisible(false);

    panel.displayWidth = rect.width * 0.55;
    panel.scaleY = panel.scaleX;

    // === 패널 위 텍스트 ===
    const jobName = this.add.text(centerX, panel.y - 30, "", {
      fontFamily: "monospace",
      fontSize: `${Math.floor(rect.height / 28)}px`,
      color: "#FFD700",
      stroke: "#000",
      strokeThickness: 4,
      resolution: 8   // ✅ 글씨 더 선명
    }).setOrigin(0.5).setVisible(false);

    const jobDesc = this.add.text(centerX, panel.y + 10, "", {
      fontFamily: "monospace",
      fontSize: `${Math.floor(rect.height / 34)}px`,
      color: "#FFFACD",
      wordWrap: { width: rect.width * 0.45 },
      resolution: 8
    }).setOrigin(0.5).setVisible(false);

    const selectBtn = this.add.text(centerX, panel.y + 50, "[ 선택하기 ]", {
      fontFamily: "monospace",
      fontSize: `${Math.floor(rect.height / 28)}px`,
      color: "#FFA500",
      stroke: "#000",
      strokeThickness: 3,
      backgroundColor: "#333",
      resolution: 8
    }).setOrigin(0.5).setInteractive().setVisible(false);

    selectBtn.on("pointerover", () => selectBtn.setStyle({ color: "#FFFF00" }));
    selectBtn.on("pointerout", () => selectBtn.setStyle({ color: "#FFA500" }));

    let currentJob = null;

    // === 패널 보여주는 함수 ===
    const showPanel = (job) => {
      currentJob = job;
      let name, desc;

      if (job === "warrior") {
        name = "⚔️ 전사 (Warrior)";
        desc = "튼튼한 방어력과 강력한 근접 공격을 가진 전사.";
      } else if (job === "mage") {
        name = "🔮 마법사 (Magician)";
        desc = "아직 미구현된 대상입니다.";
      }

      panel.setVisible(true);
      jobName.setText(name).setVisible(true);
      jobDesc.setText(desc).setVisible(true);
      selectBtn.setVisible(true);

      const targetY = rect.height * 0.78;
      this.tweens.add({
        targets: panel,
        y: targetY,
        duration: 500,
        ease: "Cubic.easeOut",
        onUpdate: () => {
          jobName.y = panel.y - 40;
          jobDesc.y = panel.y;
          selectBtn.y = panel.y + 40;
        }
      });
    };

    // === 반짝임 ===
    function makeBlink(target) {
      return target.scene.tweens.add({
        targets: target,
        alpha: 0.5,
        duration: 300,
        yoyo: true,
        repeat: -1,
        ease: "Sine.easeInOut"
      });
    }

	warrior.on("pointerdown", () => {
	  showPanel("warrior");

	  if (mageTween) { mageTween.stop(); mage.clearAlpha(); }
	  if (warriorTween) warriorTween.stop();
	  warriorTween = makeBlink(warrior);

	  // ✅ 선택 버튼: 전사는 씬 이동
	  selectBtn.removeAllListeners(); // 기존 이벤트 제거
	  selectBtn.on("pointerdown", () => {
	    this.scene.start("IntroScene", { job: "warrior" });
	  });
	});


	// === 마법사 클릭 ===
	mage.on("pointerdown", () => {
	  showPanel("mage");

	  if (warriorTween) { warriorTween.stop(); warrior.clearAlpha(); }
	  if (mageTween) mageTween.stop();
	  mageTween = makeBlink(mage);

	  // ✅ 선택 버튼: 마법사는 경고 메시지
	  selectBtn.removeAllListeners();
	  selectBtn.on("pointerdown", () => {
	    const warningMsg = this.add.text(centerX, rect.height * 0.92, "⚠️ 전사로 선택해주세요!", {
	      fontFamily: "monospace",
	      fontSize: `${Math.floor(rect.height / 28)}px`,
	      color: "#FF4444",
	      stroke: "#000",
	      strokeThickness: 4,
	      resolution: 8
	    }).setOrigin(0.5).setDepth(10);

	    // 2초 후 메시지 자동 제거
	    this.time.delayedCall(2000, () => warningMsg.destroy());
	  });
	});
	this.events.on("shutdown", () => {
	  this.input.keyboard.removeAllListeners();
	  this.input.removeAllListeners();
	});
	  }
	}
