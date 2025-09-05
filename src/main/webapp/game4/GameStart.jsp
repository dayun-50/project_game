<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>
function startGame4() {
  // 기존 Game4 인스턴스 제거
if (window.game4) { window.game4.destroy(true); window.game4 = null; }

  // 새로운 Game4 인스턴스 생성
  let config = {
    type: Phaser.AUTO,
    parent: "screen",
    width: 1280,
    height: 720,
    backgroundColor: '#000000',
    physics: {
      default: "arcade",
      arcade: { gravity: { y: 0 }, debug: false }
    },
    scene: [
      TitleScene,
      JobScene,
      IntroScene,
      StoryScene,
      Game4Scene,
      Game4OverScene,
      Game4WinScene
    ],
    scale: {
      mode: Phaser.Scale.RESIZE,
      autoCenter: Phaser.Scale.CENTER_BOTH
    }
  };

  window.game4 = new Phaser.Game(config); // ✅ 여기서도 game4로!
}
