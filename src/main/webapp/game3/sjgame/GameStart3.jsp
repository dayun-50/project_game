<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
function startGame3() {
  // 기존 Game3 인스턴스 제거
  if (window.game3) {
    window.game3.destroy(true);
    window.game3 = null;
  }

  let config = {
    type: Phaser.AUTO,
    parent: "screen",
    width: 1280,
    height: 720,
    physics: { default: "arcade", arcade: {} },
    scene: [gamestart3, game3play, game3over],
    scale: { mode: Phaser.Scale.RESIZE, autoCenter: Phaser.Scale.CENTER_BOTH }
  };

  // ✅ Game3 전역 변수
  window.game3 = new Phaser.Game(config);
}