class gameplay extends Phaser.Scene {
    constructor() {
        super({ key: "gameplay" });
    }

    init() {
        this.frame = 0;
        this.baseSpeed = 100;
        this.speedIncrease = 10;
        this.elapsed = 0;
    }

    preload() {
        const basePath = "sjgame/";

        this.load.image("player", basePath + "player.png");
        this.load.image("back", basePath + "back.jpg");
        for(let i=1;i<=8;i++) this.load.image(`s${i}`, basePath + `s${i}.png`);
        this.load.image("fire", basePath + "fire.png");
        this.load.image("water", basePath + "water.png");
    }

    create() {
        const { width, height } = this.scale;

        // 배경
        this.background = this.add.image(0, 0, "back").setOrigin(0).setDisplaySize(width, height);

        // 플레이어
        this.player = this.physics.add.sprite(width / 2, height - 100, "player");
        this.player.setCollideWorldBounds(true).setScale(0.5).setSize(50, 100);

        // 장애물 그룹
        this.boxGroup = this.physics.add.group();

        // 충돌 처리
        this.physics.add.collider(this.player, this.boxGroup, () => {
            this.scene.start("gameover", { finalTime: this.elapsed.toFixed(2) });
        });

        // 키보드
        this.cursor = this.input.keyboard.createCursorKeys();
        this.speed = 400;

        // 시간 표시
        this.timerText = this.add.text(10, 10, "Time: 0.0", {
            font: "20px Arial",
            fill: "#ffffff",
            stroke: "#000000",
            strokeThickness: 3
        });

        // 타이머 이벤트
        this.timerEvent = this.time.addEvent({
            delay: 100,
            loop: true,
            callback: () => { this.elapsed += 0.1; }
        });

        this.boxImages = ["s1","s2","s3","s4","s5","s6","s7","s8","fire","water"];

        // 화면 리사이즈 이벤트 처리
        this.scale.on('resize', (gameSize) => {
            const { width, height } = gameSize;
            this.background.setDisplaySize(width, height);
            this.player.setPosition(width / 2, height - 100);
        });
    }

    update() {
        this.frame++;

        if(this.frame % 60 === 0){
            const currentSpeed = this.baseSpeed + this.elapsed * this.speedIncrease;
            const boxCount = 1 + Math.floor(this.elapsed / 5);

            for(let i=0;i<boxCount;i++){
                const randIndex = Math.floor(Math.random()*this.boxImages.length);
                const boxName = this.boxImages[randIndex];
                // 화면 너비에 맞게 장애물 생성
                const box = this.boxGroup.create(Math.random() * this.scale.width, 0, boxName);
                box.setScale(0.1).setVelocityY(currentSpeed).setCollideWorldBounds(false);
            }
        }

        // 플레이어 좌/우 이동
        this.player.setVelocityX(0);
        if(this.cursor.left.isDown) this.player.setVelocityX(-this.speed);
        else if(this.cursor.right.isDown) this.player.setVelocityX(this.speed);

        // 시간 표시 갱신
        this.timerText.setText("Time: " + this.elapsed.toFixed(2));
    }
}
