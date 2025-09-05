class Game4Scene extends Phaser.Scene {
  constructor() { super("Game4Scene"); }

  preload() {
	this.load.setBaseURL("/game4");
    this.load.image('gamebg','asset/맵 배경.png');
    this.load.spritesheet('warrior_walk', 'asset/테스트.png', { frameWidth: 95, frameHeight: 87 });
    this.load.spritesheet('boss_idle',   'asset/boss_idle.png',   { frameWidth: 288, frameHeight: 160 });
    this.load.spritesheet('boss_walk',   'asset/boss_walk.png',   { frameWidth: 288, frameHeight: 160 });
    this.load.spritesheet('boss_attack', 'asset/boss_attack.png', { frameWidth: 288, frameHeight: 160 });
    this.load.spritesheet("boss_death", "asset/boss_death.png", { frameWidth: 316, frameHeight: 162 });

    // === 보스 HP바 이미지 (메이플 스타일) ===
    this.load.image("boss_hp_bg", "asset/empty health bar.png");   // 빈 바
    this.load.image("boss_hp_fill", "asset/health.png");           // 빨간 게이지
    this.load.image("health_bar", "asset/health_bar.png");
    this.load.image("health_bar_decoration", "asset/health_bar_decoration.png");
  }

  create() {
	
    //점수
    this.score=0;
	
    // === HP 값 ===
    this.playerHP = 100; this.playerMaxHP = 100;
    this.bossHP = 200;   this.bossMaxHP = 200;


    const scale=5;
    // === 보스 능력치 ===
    this.bossSpeed = 300;
    this.bossDmage = 5;
    this.bossAttackRange = 250;
    this.bossAttackCooldown = 0;

    this.phaseTwoStarted = false;
    this.cameras.main.stopFollow();
    this.attackCooldown = 0;

    // === 플레이어 체력 UI (기존 유지) ===
    this.deco = this.add.image(-400,800, "health_bar_decoration")
      .setOrigin(0, 0).setScrollFactor(0).setScale(scale);

    const innerOffsetX =40*scale/3;
    const innerOffsetY =scale/3;
    const innerWidth   = this.deco.displayWidth -30*scale/3;
    const innerHeight  = this.deco.displayHeight - 15*scale/3;



    this.bar = this.add.image(this.deco.x + innerOffsetX, this.deco.y + innerOffsetY, "health_bar")
      .setOrigin(0, 0).setScrollFactor(0);
    this.bar.defaultWidth  = innerWidth;
    this.bar.displayWidth  = innerWidth
    this.bar.displayHeight = innerHeight;
    this.bar.setScale(5,5);
    // === 보스 체력 UI (메이플 스타일) ===
    const screenCenterX = this.cameras.main.width / 2;

    this.bossHpBg = this.add.image(screenCenterX, 10, "boss_hp_bg") // 중앙 위쪽
      .setOrigin(0.5, 0)
      .setScale(2.5);

    this.bossHpBar = this.add.image(this.bossHpBg.x, this.bossHpBg.y + 50, "boss_hp_fill")
      .setOrigin(0.5, 0)
     

    this.bossHpBar.defaultWidth = this.bossHpBg.displayWidth ;
    this.bossHpBar.displayWidth = this.bossHpBar.defaultWidth;
    this.bossHpBar.displayHeight = 35;
    
    // 숫자 표시
    this.bossHpText = this.add.text(this.bossHpBg.x, this.bossHpBg.y + this.bossHpBg.displayHeight + 10,
      `${this.bossHP} / ${this.bossMaxHP}`, {
        fontSize: "28px",
        color: "#ffffff",
        fontStyle: "bold",
        stroke: "#000000",
        strokeThickness: 4
      })
      .setOrigin(0.5, 0)
   

    // === 배경 ===
    const bgWidth  = this.textures.get('gamebg').getSourceImage().width;
    const bgHeight = this.textures.get('gamebg').getSourceImage().height;
    const WORLD_W = bgWidth * 3;
    const WORLD_H = bgHeight;
    for (let i = 0; i < 3; i++) {
      this.add.image(i * bgWidth, 0, 'gamebg').setOrigin(0, 0).setDepth(-1);
    }
    this.cameras.main.setBounds(0, 0, WORLD_W, WORLD_H);
    this.physics.world.setBounds(0, 0, WORLD_W, WORLD_H);
    this.physics.world.gravity.y = 2000;

    // === 바닥 ===
    const groundHeight = 50;
    const groundY = WORLD_H - groundHeight / 2;
    this.ground = this.add.rectangle(WORLD_W/2, groundY, WORLD_W, groundHeight);
    this.physics.add.existing(this.ground, true);
    this.groundTop = groundY - groundHeight/2;

    // === 플레이어 ===
    this.player = this.physics.add.sprite(200, this.groundTop, 'warrior_walk', 1)
      .setOrigin(0.5,1).setScale(3);
    this.player.body.setSize(40,60).setOffset(25,5);
    this.player.setCollideWorldBounds(true);
    this.physics.add.collider(this.player, this.ground);

    // === 플레이어 공격 히트박스 ===
    this.playerAttackBox = this.add.rectangle(this.player.x, this.player.y, 60, 30, 0x00ff00, 0.4);
    this.physics.add.existing(this.playerAttackBox);
    this.playerAttackBox.body.setAllowGravity(false);
    this.playerAttackBox.body.enable = false;
    this.playerAttackBox.setVisible(false);

    // === 애니메이션 ===
    this.anims.create({ key:'walk', frames:this.anims.generateFrameNumbers('warrior_walk',{start:21,end:24}), frameRate:8, repeat:-1 });
    this.anims.create({ key:'boss_idle',   frames:this.anims.generateFrameNumbers('boss_idle',{start:0,end:5}), frameRate:6,  repeat:-1 });
    this.anims.create({ key:'boss_walk',   frames:this.anims.generateFrameNumbers('boss_walk',{start:0,end:11}), frameRate:6,  repeat:-1 });
    this.anims.create({ key:'boss_attack', frames:this.anims.generateFrameNumbers('boss_attack',{start:0,end:14}), frameRate:10, repeat:0 });
    this.anims.create({ key:'boss_death',  frames:this.anims.generateFrameNumbers('boss_death',{start:0,end:10}), frameRate:12, repeat:0 });

    // === 보스 ===
    this.boss = this.physics.add.sprite(WORLD_W - 200, this.groundTop, 'boss_idle', 0)
      .setOrigin(0.5,1).setScale(5);
    this.boss.body.setSize(100,160).setOffset(90,0);
    this.boss.setCollideWorldBounds(true);
    this.physics.add.collider(this.boss, this.ground);
    this.boss.play('boss_idle');
    this.bossState = 'idle';

    // === 보스 공격 히트박스 ===
    this.bossAttackBox = this.add.rectangle(this.boss.x, this.boss.y, 120, 50, 0xff0000, 0.4);
    this.physics.add.existing(this.bossAttackBox);
    this.bossAttackBox.body.setAllowGravity(false);
    this.bossAttackBox.body.enable = false;
    this.bossAttackBox.setVisible(false);
    this.bossAttackBox.alreadyHit = false;

    // === 충돌 체크 ===
    this.physics.add.overlap(this.player, this.bossAttackBox, () => {
      if (this.bossAttackBox.body.enable && !this.bossAttackBox.alreadyHit) {
        this.damagePlayer(this.bossDmage);
        this.bossAttackBox.alreadyHit = true;
      }
    });
    this.physics.add.overlap(this.boss, this.playerAttackBox, () => {
      if (this.playerAttackBox.body.enable && !this.playerAttackBox.alreadyHit) {
        this.damageBoss(1);
        this.playerAttackBox.alreadyHit = true;
      }
    });

    // === 카메라 ===
    this.cameras.main.startFollow(this.player, true, 0.12, 0.12).setZoom(0.5);
    this.cursors = this.input.keyboard.createCursorKeys();

     // === 보스 공격 애니메이션 프레임별 판정 추가 ===
       this.boss.on('animationupdate', (anim, frame) => {
      if (anim.key === 'boss_attack') {
        this.bossAttackBox.body.enable = false;
        this.bossAttackBox.setVisible(false);

        if (frame.index === 9 || frame.index === 10) {
          this.bossAttackBox.body.enable = true;
          this.bossAttackBox.setVisible(true);
          this.bossAttackBox.alreadyHit = false;

          const distance = Phaser.Math.Distance.Between(this.player.x, this.player.y, this.boss.x, this.boss.y);

          if (distance < 120) {
            // 겹치면 플레이어 위치에서 공격
            this.bossAttackBox.body.reset(this.player.x, this.player.y - 50);
            this.bossAttackBox.body.setSize(80, 60);
          } else {
            // 평소엔 앞쪽으로
            const offsetX = this.boss.flipX ? 320 : -320;
            const offsetY = -20;
            this.bossAttackBox.body.reset(this.boss.x + offsetX, this.boss.y + offsetY);

            if (this.phaseTwoStarted) {
              this.bossAttackBox.body.setSize(160, 60);
            } else {
              this.bossAttackBox.body.setSize(100, 50);
            }
          }
        }
      }
    });

    // === 보스 공격 애니메이션 끝 처리 ===
    this.boss.on('animationcomplete', (anim) => {
      if (anim.key === 'boss_attack') {
        this.bossAttackBox.body.enable = false;
        this.bossAttackBox.setVisible(false);

        this.bossState = 'idle_after_attack';
        this.boss.play('boss_idle');

        this.bossAttackCooldown = 1500; 
        this.time.delayedCall(1500, () => {
          if (!this.boss || this.boss.isDead) return;
          this.bossState = 'chase';
          this.boss.play('boss_walk');
        });
      }
    });

    // === 보스 인트로 ===
    this.startBossIntro();
  }

  startBossIntro(){
    const cam=this.cameras.main;
    cam.pan(this.boss.x, this.boss.y - 200, 2000, 'Sine.easeInOut');

    this.time.delayedCall(2000,()=>{ this.showBossDialog("감히… 내 영역에 발을 들이다니 죽여주마"); });
    this.time.delayedCall(5000,()=>{
      if(this.dialogBox) this.dialogBox.destroy();
      if(this.dialogText) this.dialogText.destroy();
      cam.startFollow(this.player, true, 0.12, 0.12).setZoom(0.5);
      this.bossState = 'chase';
      this.boss.play('boss_walk');
    });
  }

  showBossDialog(text) {
    const width = 600, height = 150;
    this.dialogBox = this.add.rectangle(
      this.cameras.main.width / 2,
      this.cameras.main.height - 400,
      width, height, 0x000000, 0.6
    ).setOrigin(0.5).setScrollFactor(0).setDepth(9999);

    this.dialogText = this.add.text(
      this.dialogBox.x, this.dialogBox.y+20, text,
      { fontSize: '32px', color: '#ff0000', align: 'center', wordWrap: { width: width - 20 } }
    ).setOrigin(0.5).setScrollFactor(0).setDepth(10000);
  }

  damagePlayer(amount) {
    this.playerHP = Math.max(this.playerHP - amount, 0);
    this.bar.displayWidth = this.bar.defaultWidth * (this.playerHP / this.playerMaxHP);
    //this.bar.x = this.deco.x + 45;

    this.cameras.main.shake(200, 0.01);
    this.player.setTintFill(0xff0000);
    this.time.delayedCall(150, () => this.player.clearTint());

    const knockback = (this.player.x < this.boss.x) ? -200 : 200;
    this.player.setVelocityX(knockback);

    //체력0이면
    if(this.playerHP <= 0){
		console.log("죽음 조건 발동");
		$.ajax({
		  url: "/score.GameController",   // ✅ GameController 매핑 주소
		  type: "POST",
		  data: {
		    game_id: 4,                  // 게임 번호 (예: 4번 게임)
		    user_name: window.userName,  // JSP에서 세션 값 전달
		    score: this.score            // 넘겨받은 점수
		  },
		  
		  	});
  this.scene.start("Game4OverScene", { score: this.score, result: "YOU DIED" });
}
  }

  damageBoss(amount) {
    this.bossHP = Math.max(this.bossHP - amount, 0);

    this.score+=10;

    // === 보스 체력바 업데이트 ===
    const ratio = this.bossHP / this.bossMaxHP;
    this.bossHpBar.displayWidth = this.bossHpBar.defaultWidth * ratio;

    // 숫자 업데이트
    this.bossHpText.setText(`${this.bossHP} / ${this.bossMaxHP}`);

    this.tweens.add({
  targets: this.boss,
  alpha: 0.5,
  yoyo: true,
  duration: 100,
  repeat: 2,
  onComplete: () => { 
    if (this.boss) this.boss.alpha = 1; // ✅ 보스 존재할 때만 처리
  }
});

    if(!this.phaseTwoStarted && this.bossHP <= this.bossMaxHP /2){
      this.phaseTwoStarted=true;
      this.boss.setVelocityX(0);
      this.boss.play('boss_idle');
      this.showBossDialog("제법이구나 애송이 주제에!");
      this.cameras.main.flash(500, 255, 0, 0);
      this.cameras.main.shake(500, 0.01);

      this.time.delayedCall(3000, () => {
        if(this.dialogBox) this.dialogBox.destroy();
        if(this.dialogText) this.dialogText.destroy();

        this.bossSpeed=450;
        this.bossAttackRange=400;
        this.bossAttackCooldown=600;
        this.bossDmage=15;

        this.boss.play('boss_walk');
        this.bossState = 'chase';
        this.physics.moveToObject(this.boss, this.player, this.bossSpeed);
      });
    }

    if(this.bossHP <= 0){
      this.score += 500;
      this.killBoss();
    }
  }

  killBoss(){
    if(!this.boss || this.boss.isDead) return;
    this.boss.isDead = true;

    this.boss.setVelocity(0,0);

    if (this.bossAttackBox) {
      this.bossAttackBox.destroy();
      this.bossAttackBox = null;
    }

    this.boss.anims.stop();
    this.boss.play('boss_death');

    this.showBossDialog("으... 내가 이딴 애송이한테 지다니...");

    this.boss.once('animationcomplete-boss_death',()=>{
      this.fadeAndDestroyBoss();
    });

    // this.time.delayedCall(500, () => {
    //   this.fadeAndDestroyBoss();
    // });

      this.time.delayedCall(2000, () => {
    if(this.dialogBox) { this.dialogBox.destroy(); this.dialogBox = null; }
    if(this.dialogText) { this.dialogText.destroy(); this.dialogText = null; }
  });
  }

fadeAndDestroyBoss(){
  if(!this.boss) return;
  const bossRef = this.boss; // 안전 참조
  this.tweens.add({
    targets: bossRef,
    alpha:0,
    duration:400,
    onComplete:()=>{
      if (bossRef) bossRef.destroy();
      this.boss = null;

      if (this.bossHpBar) { this.bossHpBar.destroy(); this.bossHpBar = null; }
      if (this.bossHpBg) { this.bossHpBg.destroy(); this.bossHpBg = null; }
      if (this.bossHpText) { this.bossHpText.destroy(); this.bossHpText = null; }
	  $.ajax({
	  			  url: "/score.GameController",   // ✅ GameController 매핑 주소
	  			  type: "POST",
	  			  data: {
	  			    game_id: 4,                  // 게임 번호 (예: 4번 게임)
	  			    user_name: window.userName,  // JSP에서 세션 값 전달
	  			    score: this.score            // 넘겨받은 점수
	  			  },
				
	  			  	});
					
	  	
      this.scene.start("Game4WinScene",{score:this.score,result:"You WIN"});
	  
    }
  });
}

  update(time, delta) {
    const speed = 300;
    const attackDelay = 200;
    const offsetY=400;
    

	if (this.boss && !this.boss.isDead) {
	   if (this.bossHpBg)  this.bossHpBg.setPosition(this.boss.x, this.boss.y - offsetY);
	   if (this.bossHpBar) this.bossHpBar.setPosition(this.boss.x, this.boss.y - offsetY);
	   if (this.bossHpText) this.bossHpText.setPosition(this.boss.x, this.boss.y - offsetY - 20);
	 }

    if (this.attackCooldown > 0) this.attackCooldown -= delta;

    if (this.cursors.left.isDown) {
      this.player.setVelocityX(-speed);
      this.player.flipX = false;
      this.player.play('walk', true);

      if (this.attackCooldown <= 0) {
        this.playerAttackBox.body.enable = true;
        this.playerAttackBox.setVisible(true);
        this.playerAttackBox.body.reset(this.player.x - 40, this.player.y - 90);
        this.playerAttackBox.body.setSize(70, 40);
        this.playerAttackBox.alreadyHit = false;

        this.time.delayedCall(attackDelay, () => {
          this.playerAttackBox.body.enable = false;
          this.playerAttackBox.setVisible(false);
        });
        this.attackCooldown = attackDelay;
      }
    } else if (this.cursors.right.isDown) {
      this.player.setVelocityX(speed);
      this.player.flipX = true;
      this.player.play('walk', true);

      if (this.attackCooldown <= 0) {
        this.playerAttackBox.body.enable = true;
        this.playerAttackBox.setVisible(true);
        this.playerAttackBox.body.reset(this.player.x + 40, this.player.y - 90);
        this.playerAttackBox.body.setSize(70, 40);
        this.playerAttackBox.alreadyHit = false;

        this.time.delayedCall(attackDelay, () => {
          this.playerAttackBox.body.enable = false;
          this.playerAttackBox.setVisible(false);
        });
        this.attackCooldown = attackDelay;
      }
    } else {
      this.player.setVelocityX(0);
      this.player.anims.stop();
      this.player.setFrame(1);
    }

    if (!this.boss || this.boss.isDead) return;

    const distance = Phaser.Math.Distance.Between(this.player.x, this.player.y, this.boss.x, this.boss.y);
    if (this.bossAttackCooldown > 0) this.bossAttackCooldown -= delta;

    if (this.bossState === 'idle') {
      this.boss.setVelocityX(0);
      this.boss.play('boss_idle', true);
      this.bossState = 'chase';
      this.boss.play('boss_walk');
    }
    else if (this.bossState === 'chase') {
      if (this.bossAttackCooldown <= 0) {
        if (distance < this.bossAttackRange) {
          this.bossState = 'attack';
          this.boss.setVelocityX(0);
          this.boss.flipX = (this.player.x > this.boss.x);
          this.boss.play('boss_attack');
        } else {
          if (this.player.x < this.boss.x - 50) {
            this.boss.setVelocityX(-this.bossSpeed);
            this.boss.flipX = false;
          } else if (this.player.x > this.boss.x + 50) {
            this.boss.setVelocityX(this.bossSpeed);
            this.boss.flipX = true;
          } else {
            this.boss.setVelocityX(0);
          }
        }
      }
    }
    else if (this.bossState === 'retreat') {
      if (this.player.x < this.boss.x) {
        this.boss.setVelocityX(this.bossSpeed);
        this.boss.flipX = true;
      } else {
        this.boss.setVelocityX(-this.bossSpeed);
        this.boss.flipX = false;
      }
      if (distance >= 120) {
        this.bossState = 'chase';
        this.boss.play('boss_walk', true);
      }
    }
  }
}
