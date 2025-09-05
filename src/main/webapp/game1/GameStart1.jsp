<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
function startGame1() {
  // 기존 Game1 인스턴스 제거
  if (window.game1) {
    window.game1.destroy(true);
    window.game1 = null;
  }

  let config = {
    type: Phaser.AUTO,
    parent: "screen",
    width: 1280,
    height: 720,
    physics: { default: "arcade", arcade: {} },
    scene: [Exam03, Exam04],
    scale: { mode: Phaser.Scale.RESIZE, autoCenter: Phaser.Scale.CENTER_BOTH }
  };

  // ✅ Game3 전역 변수
  window.game1 = new Phaser.Game(config);
}

