class Game2Scene extends Phaser.Scene {
  constructor() { 
    super('Game2Scene'); 
  }

  preload() {  
    this.load.image('player','/game2/asset/player.png'); 
    this.load.image('map','/game2/asset/찐배경.png'); 
    this.load.image('flameBeam', '/game2/asset/검기테스트.png'); 
    this.load.image('enemy', '/game2/asset/투명 투척모션.png'); 
    this.load.image('shuriken', '/game2/asset/표창.png'); 
    this.load.image('hitEnemy', '/game2/asset/피격모션4.png'); 

    // === 보스 스프라이트 (순서: 아카자 → 코쿠시보 → 무잔) ===
    this.load.image('akaza',      '/game2/asset/아카자.png');
    this.load.image('kokushibo',  '/game2/asset/코쿠시보.png');
    this.load.image('muzan',      '/game2/asset/무잔.png');

    // 보스별 전용 피격/사망 스프라이트
    this.load.image('akazaHit',     '/game2/asset/아카자피격.png'); 
    this.load.image('kokushiboHit', '/game2/asset/코쿠시보피격.png'); 
    this.load.image('bossHit', '/game2/asset/보스피격.png');
  }

  create() {
    // 배경
    this.background = this.add.tileSprite(
      this.cameras.main.width / 2,
      this.cameras.main.height / 2,
      this.cameras.main.width,
      this.cameras.main.height,
      'map'
    );
    const scaleX = this.cameras.main.width / this.background.width;
    const scaleY = this.cameras.main.height / this.background.height;
    const scale = Math.max(scaleX, scaleY); 
    this.background.setScale(scale);

    // === 플레이어 (현재 스케일 0.07 유지) ===
    this.player = this.physics.add.sprite(200, 500, 'player')
      .setScale(0.07)
      .setOrigin(0.5, 1) // 아래쪽 중심
      .setCollideWorldBounds(true);
    this.player.setFlipX(true);

    // === 플레이어 히트박스 축소 & 오리진 기준 정렬 ===
    const texW = this.player.width;
    const texH = this.player.height;
    const bw = texW * 0.35;  // 폭 줄이기
    const bh = texH * 1;     // 높이 줄이기
    this.player.body.setSize(bw, bh);
    this.player.body.setOffset((texW - bw) / 2, texH - bh);

    // 그룹
    this.beams = this.physics.add.group();
    this.enemies = this.physics.add.group();
    this.shurikens = this.physics.add.group();

    // 입력
    this.cursors = this.input.keyboard.createCursorKeys();
    this.spaceKey = this.input.keyboard.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE);

    this.lastFireTime = 0;
    this.fireInterval = 120;

    // === 스코어 ===
    this.score = 0;
    this.scoreText = this.add.text(
      this.cameras.main.width - 20, 14,
      'Score: 0',
      { fontFamily: 'Arial', fontSize: '28px', color: '#ffffff' }
    ).setOrigin(1, 0).setDepth(1000).setScrollFactor(0);

    // 적 스폰
    this.time.addEvent({
      delay: 1500,           
      callback: this.spawnEnemy,
      callbackScope: this,
      loop: true
    });

    // ===== 보스 라운드 진행 상태 =====
    this.bossOrder = ['akaza', 'kokushibo', 'muzan'];
    this.bossIndex = 0;
    this.currentBoss = null;

    // 첫 보스 출현 (10초 뒤)
    this.time.delayedCall(10000, () => this.spawnBoss());

    // 충돌
    this.physics.add.overlap(this.player, this.shurikens, this.hitPlayer, null, this);
    this.physics.add.overlap(this.player, this.enemies, this.hitPlayer, null, this);
    this.physics.add.overlap(this.beams, this.enemies, this.hitEnemy, null, this);
  }

  addScore(amount) {
    this.score += amount;
    this.scoreText.setText(`Score: ${this.score}`);
  }

  update(time) {
    this.background.tilePositionX += 2;

    this.player.setVelocity(
      (this.cursors.left.isDown ? -300 : this.cursors.right.isDown ? 300 : 0),
      (this.cursors.up.isDown ? -300 : this.cursors.down.isDown ? 300 : 0)
    );

    if (Phaser.Input.Keyboard.JustDown(this.spaceKey)) {
      if (time - this.lastFireTime >= this.fireInterval) {
        this.lastFireTime = time;
        this.shootFlame();
      }
    }

    this.beams.children.each(beam => {
      if (beam && beam.x > this.cameras.main.width + 50) beam.destroy();
    });

    this.enemies.children.each(enemy => {
      if (!enemy) return;
      if (enemy.isBoss && enemy.isDead) {
        if (enemy.y > this.cameras.main.height + enemy.displayHeight) enemy.destroy();
        return;
      }
      if (enemy.y > this.cameras.main.height + 50 || enemy.x < -50) {
        if (enemy.shootTimer) enemy.shootTimer.remove();
        // ★ 일반 적의 지연 타이머도 정리
        if (enemy.spawnTimer) enemy.spawnTimer.remove(); // ★
        enemy.destroy();
      }
    });

    this.shurikens.children.each(shuriken => {
      if (shuriken && (shuriken.x < -50 || shuriken.x > this.cameras.main.width + 50 || shuriken.y < -50 || shuriken.y > this.cameras.main.height + 50)) {
        shuriken.destroy();
      }
    });
  }

  shootFlame() {
    const beam = this.beams.create(this.player.x + 10, this.player.y, 'flameBeam');
    beam.setVelocityX(500);
    beam.body.allowGravity = false;
    beam.setOrigin(0, 0.5);
    beam.setBlendMode(Phaser.BlendModes.ADD);
    beam.setDepth(10);
    beam.setScale(0.3);
    beam.body.setSize(500, 200);

    this.time.delayedCall(1200, () => { if (beam && beam.active) beam.destroy(); });
  }

  spawnEnemy() {
    const spawnY = Phaser.Math.Between(50, this.cameras.main.height - 50);
    const enemy = this.enemies.create(this.cameras.main.width + 50, spawnY, 'enemy');

    // 랜덤 적 크기 = 플레이어 스케일을 그대로 따름
    enemy.setScale(this.player.scaleX, this.player.scaleY);

    enemy.setVelocityX(-200);
    enemy.body.allowGravity = false;
    enemy.isDying = false;

    // ★ 일반 적의 투척을 지연 호출로 예약하고, 핸들을 보관
    enemy.spawnTimer = this.time.delayedCall(1200, () => this.throwShurikens(enemy)); // ★
  }

  // === 표창(수리켄) ===
  throwShurikens(enemy) {
    // ★ 죽은(혹은 죽는 중) 적은 투척 금지
    if (!enemy.active || enemy.isDying) return; // ★

    const enemyBounds = enemy.getBounds();
    const centerX = enemyBounds.left;
    const centerY = enemy.y;
    const baseSpeed = 200;
    for (let i = 0; i < 3; i++) {
      const angleRad = Phaser.Math.DegToRad(Phaser.Math.Between(120, 200));
      const shuriken = this.shurikens.create(centerX, centerY, 'shuriken');
      shuriken.setScale(0.10);
      shuriken.body.allowGravity = false;
      shuriken.setVelocity(baseSpeed * Math.cos(angleRad), baseSpeed * Math.sin(angleRad));
    }
  }

  spawnBoss() {
    if (this.bossIndex >= this.bossOrder.length) {
		$.ajax({
			  url: "/score.GameController",   // ✅ GameController 매핑 주소
			  type: "POST",
			  data: {
			    game_id: 2,                  // 게임 번호 (예: 4번 게임)
			    user_name: window.userName,  // JSP에서 세션 값 전달
			    score: this.score            // 넘겨받은 점수
			  },
			  
			  	});
      this.scene.start('ClearScene', { score: this.score });
      return;
    }

    const bossKey = this.bossOrder[this.bossIndex];
    const boss = this.enemies.create(0, 0, bossKey); 
    boss.bossKey = bossKey;
    this.currentBoss = boss;

    boss.body.allowGravity = false;
    boss.setVelocityX(0);

    const scale = (this.cameras.main.height * 0.6) / boss.displayHeight;
    boss.setScale(scale);
    boss.setOrigin(0.5, 0.5);
    boss.x = this.cameras.main.width - boss.displayWidth / 2;
    boss.y = this.cameras.main.height / 2;

    boss.isBoss = true;
    boss.health = (bossKey === 'akaza' || bossKey === 'kokushibo') ? 100 : 200;
    boss.setImmovable(true);
    boss.isDead = false;

    boss.body.setSize(600, 1000);
    boss.body.setOffset((boss.displayWidth - 50) / 2, (boss.displayHeight - 300) / 2);

    boss.shootTimer = this.time.addEvent({
      delay: 1000,
      callback: () => this.throwBossShurikens(boss),
      loop: true
    });
  }

  throwBossShurikens(boss) {
    if (!boss.active || boss.isDead) return;
    const baseSpeed = 200;
    for (let i = 0; i < 15; i++) {
      const angleRad = Phaser.Math.DegToRad(Phaser.Math.Between(90, 270));
      const shuriken = this.shurikens.create(boss.x, boss.y, 'shuriken');
      shuriken.setScale(0.10);
      shuriken.body.allowGravity = false;
      shuriken.setVelocity(baseSpeed * Math.cos(angleRad), baseSpeed * Math.sin(angleRad));
    }
  }

  hitPlayer(player, obj) {
	$.ajax({
			  url: "/score.GameController",   // ✅ GameController 매핑 주소
			  type: "POST",
			  data: {
			    game_id: 2,                  // 게임 번호 (예: 4번 게임)
			    user_name: window.userName,  // JSP에서 세션 값 전달
			    score: this.score            // 넘겨받은 점수
			  },
			  
			  	});
    this.scene.start('Game2OverScene', { score: this.score });
  }

  hitEnemy(beam, enemy) {
    // ★ 죽은(보스) / 죽는 중(일반) 적과의 충돌은 '무시'하여 검기가 사라지지 않게 함
	if ((enemy && enemy.isBoss) ? enemy.isDead : enemy.isDying) {
	   return;
    }

    if (beam && beam.active) beam.destroy();

    if (enemy.isBoss) {
      if (enemy.isDead) return;
      enemy.health -= 1;
      enemy.setTint(0xff0000);
      this.time.delayedCall(100, () => { if (enemy.active) enemy.clearTint(); });

      if (enemy.health <= 0) {
        if (enemy.shootTimer) enemy.shootTimer.remove();
        this.addScore(10000);
        enemy.isDead = true;

        // ★ 죽은 보스는 충돌 제거 (시체는 아래로 내려가되 검기/플레이어와 충돌 안 함)
        if (enemy.body) enemy.body.checkCollision.none = true; // ★

        switch (enemy.bossKey) {
          case 'akaza':     enemy.setTexture('akazaHit'); break;
          case 'kokushibo': enemy.setTexture('kokushiboHit'); break;
          default:          enemy.setTexture('bossHit');
        }

        enemy.setVelocity(0, 100);
        enemy.body.allowGravity = false;

        this.bossIndex += 1;

        // 마지막 보스 처치 시 클리어로 점수 전달
        if (this.bossIndex >= this.bossOrder.length) {
			if (this.currentBoss && this.currentBoss.shootTimer) {
		          this.currentBoss.shootTimer.remove();
          this.scene.start('ClearScene', { score: this.score });
          return;
        }
}
        // 다음 보스 1분 뒤 등장
        this.time.delayedCall(60000, () => this.spawnBoss());
      }
      return;
    }

    // === 일반 적 ===
    if (enemy.isDying) return;
    enemy.isDying = true;
    this.addScore(100);

    // ★ 일반 적도 죽으면 충돌 제거 (시체 하강 중 충돌 없음)
    if (enemy.body) enemy.body.checkCollision.none = true; // ★

    enemy.setTexture('hitEnemy');
    enemy.setVelocity(0, 300);
    enemy.body.allowGravity = false;

    // ★ 예약된 투척 타이머가 있으면 취소 (시체에서 표창 안 나오게)
    if (enemy.spawnTimer) enemy.spawnTimer.remove(); // ★

    if (enemy.shootTimer) enemy.shootTimer.remove();
  }
}
