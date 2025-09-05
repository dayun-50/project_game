<%@ page language="java" contentType="application/javascript; charset=UTF-8" pageEncoding="UTF-8"%>




function startGame() {
	  if (window.__phaserGame__) {
	    window.__phaserGame__.destroy(true);
	    window.__phaserGame__ = null;
	  }
	
	const screen = document.getElementById("screen");
    const rect = screen.getBoundingClientRect(); // 📏 스크린 크기 가져오기
    
	  const config = {
	    type: Phaser.AUTO,
	    width: rect.width,   // ✅ 흰 화면의 실제 너비
    	height: rect.height, // ✅ 흰 화면의 실제 높이
	    parent: "game-container",
	    physics: { default: 'arcade', arcade: { gravity: { y: 0 }, debug: false } },
	    scene: [ TitleScene, JobScene, IntroScene, StoryScene, GameScene, GameOverScene, GameWinScene ],
	     scale: {
    		mode: Phaser.Scale.RESIZE,     // ✅ 창 크기에 맞게 자동으로 늘리기
    		autoCenter: Phaser.Scale.CENTER_BOTH
  }
	    
	
	  };

	  window.__phaserGame__ = new Phaser.Game(config);
	}
