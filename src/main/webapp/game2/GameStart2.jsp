<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

function startGame2() {
  // 기존 Game1 인스턴스 제거
  if (window.game2) {
    window.game2.destroy(true);
    window.game2 = null;
  }

const config = {
  type: Phaser.AUTO,
   parent: "screen",
  width: 1280,
   height: 720,
  backgroundColor: '#000000',
  physics: {
    default: 'arcade',
    arcade: {
     // debug: true // true로 바꾸면 충돌 영역 보임
    }
  },
  scene: [TitleScene2,Game2Scene,Game2OverScene,ClearTint],
scale: { mode: Phaser.Scale.RESIZE, autoCenter: Phaser.Scale.CENTER_BOTH }
};
  // ✅ Game2전역 변수
  window.game2= new Phaser.Game(config);
}