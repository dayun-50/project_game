class Exam03 extends Phaser.Scene {
    constructor() {
        super({ key: "Exam03" });
        this.fishes = [];
        this.lasers = [];
    }

    preload() {
        this.load.image("background", "/game1/img/배경용.png"); 
        this.load.image("submarine", "/game1/img/me.png"); 
        this.load.image("fish", "/game1/img/물고기.png"); 
        this.load.image("fish2", "/game1/img/물고기2.png"); 
        this.load.image("fish3", "/game1/img/물고기3.png"); 
        this.load.image("laser", "/game1/img/laser.png"); 
    }

    create() {
        this.cameraWidth = this.cameras.main.width;
        this.cameraHeight = this.cameras.main.height;

        // 배경
        this.bg = this.add.tileSprite(0, 0, this.cameraWidth, this.cameraHeight, "background").setOrigin(0, 0);

        // 잠수함
        this.sub = this.physics.add.sprite(this.cameraWidth / 2, this.cameraHeight - 80, "submarine");
        this.sub.setScale(0.3);
        this.sub.setCollideWorldBounds(true);
        this.sub.body.setSize(this.sub.width * 0.5, this.sub.height * 0.5); // 세로 조금 줄임
        this.sub.body.setOffset(this.sub.width * 0.25, this.sub.height * 0.25); // 자연스럽게 위치 맞춤
        // 키 입력
        this.cursor = this.input.keyboard.createCursorKeys();
        this.spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);
        this.speed = 200;

        // 바닥 경계
        let bound = this.add.rectangle(this.cameraWidth / 2, this.cameraHeight + 50, this.cameraWidth, 5);
        this.physics.add.existing(bound, true);
        this.physics.add.collider(this.fishes, bound, (fish) => {
            fish.destroy();
            this.fishes = this.fishes.filter(f => f !== fish);
        });

                // create() 안에서 그룹 생성
				
				
this.fishesGroup = this.physics.add.group();
this.lasersGroup = this.physics.add.group();


        // 잠수함과 물고기 충돌
this.physics.add.overlap(this.sub, this.fishesGroup, (sub, fish) => {
	let intTime = Math.floor(this.survivalTime);
    this.physics.pause();
    setTimeout(() => {
		$.ajax({
		       url: "/score.GameController",
		       type: "POST",
		       data: {
		           game_id: 1,                  // Game1 번호
		           user_name: window.userName,  // JSP에서 세션 전달된 유저 닉네임
		           score: intTime
		       },
			   });
        this.scene.start("Exam04", { finalTime: this.survivalTime });
    }, 10);
});

        // 물고기와 레이저 충돌


// 물고기와 레이저 충돌
this.physics.add.overlap(this.lasersGroup, this.fishesGroup, (laser, fish) => {
    laser.destroy();  // 그룹에서 자동 제거됨
    fish.destroy();   // 그룹에서 자동 제거됨
});

        // 물고기 생성
        this.time.addEvent({ delay: 500, loop: true, callback: () => this.spawnFish() });

        this.survivalTime = 0;
        this.frameCount = 0;
    }

    update() {
        // 배경 스크롤
        this.bg.tilePositionY -= 2;

        // 잠수함 이동
        if (this.cursor.left.isDown) this.sub.setVelocityX(-this.speed);
        else if (this.cursor.right.isDown) this.sub.setVelocityX(this.speed);
        else this.sub.setVelocityX(0);

        // 레이저 발사
        if (Phaser.Input.Keyboard.JustDown(this.spaceKey)) this.shootLaser();

        // 생존 시간 계산
        this.frameCount++;
        if (this.frameCount % 60 === 0) this.survivalTime++;

        // 화면 밖 레이저 제거
        this.lasers.forEach((laser) => {
            if (laser.y < -10) {
                laser.destroy();
                this.lasers = this.lasers.filter(l => l !== laser);
            }
        });
    }

   // 물고기 생성
spawnFish() {
    let fishTypes = ["fish", "fish2", "fish3"];
    let type = Phaser.Utils.Array.GetRandom(fishTypes);
    let x = Phaser.Math.Between(25, this.cameraWidth - 25);

    // 그룹에 직접 생성
    let fish = this.fishesGroup.create(x, -50, type);
    fish.setScale(0.2);
    fish.setVelocityY(Phaser.Math.Between(100, 200));
    fish.flipY = true;
    fish.body.setSize(fish.width * 0.3, fish.height * 0.4);
    fish.body.setOffset(fish.width * 0.35, fish.height * 0.35);
}

// 레이저 발사
shootLaser() {
    let laser = this.lasersGroup.create(this.sub.x, this.sub.y - 30, "laser");
    laser.setVelocityY(-400);
    laser.setScale(0.5);
     laser.body.setSize(laser.width * 0.1, laser.height * 0.4); 
}
}
