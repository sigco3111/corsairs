# ⚓ Corsairs: Wind of Freedom — 한국어판

[![Tests](https://github.com/sigco3111/corsairs/actions/workflows/tests.yml/badge.svg)](https://github.com/sigco3111/corsairs/actions/workflows/tests.yml)
[![Godot 4.7](https://img.shields.io/badge/Godot-4.7-478cbf?logo=godotengine&logoColor=white)](https://godotengine.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 이 저장소는 [Elkhan-Isayev/corsairs](https://github.com/Elkhan-Isayev/corsairs)(MIT 라이선스)의 **한국어 번역 포크**입니다.
> 원작자는 Elkhan Isayev이며, 원문 README는 [README.en.md](README.en.md)에 그대로 보존되어 있습니다.

**Corsairs: Wind of Freedom**은 [Pirates of the Caribbean (2003)](https://en.wikipedia.org/wiki/Pirates_of_the_Caribbean_(video_game)) — 러시아에서는 *Sea Dogs II*(«Корсары 2», Akella)로 알려진 — 에서 영감을 받아 **Godot 4.7**로 처음부터 새로 만든 오픈소스 해양 RPG입니다. 원작 게임의 에셋은 전혀 사용되지 않았으며, 별도의 원본 게임 파일 없이 실행됩니다.

## 🎮 지금 플레이 (한국어판)

**https://sigco3111.github.io/corsairs/**

브라우저에서 바로 실행됩니다. 설치가 필요 없으며, main 브랜치에 푸시될 때마다 GitHub Actions가 웹 빌드를 자동으로 다시 만들어 Pages에 배포합니다. 데스크톱(키보드+마우스) 환경을 권장합니다.

원본 영어판: https://elkhan-isayev.github.io/corsairs/

---

## 스크린샷

| 해전 | 항구 마을 (걸어다니는 3D) |
|---|---|
| ![Sea battle](docs/screenshots/battle.png) | ![Port town](docs/screenshots/town.png) |

| 백병전 | 선술집 내부 |
|---|---|
| ![Boarding melee](docs/screenshots/boarding.png) | ![Tavern interior](docs/screenshots/interior.png) |

| 먼바다 (세계 지도) | 항구 메뉴 |
|---|---|
| ![The open sea](docs/screenshots/map.png) | ![Port menu](docs/screenshots/port.png) |

*위 스크린샷은 원본 영어판 화면입니다. 한국어판 화면은 아래 "한국어판 안내"에 추가될 수 있습니다.*

## 주요 특징

- 🌊 **3D 해전** — 실제 바람 모델의 항해 물리, 좌현/우현 독립 포대, 포문마다 피어나는 연기, 적 AI, 백병전, 침몰, 그리고 최대 4척 편대. 모두 침몰시키면 바다는 당신의 것입니다. 충분히 멀어지면 세계 지도로 탈출할 수 있습니다.
- 💣 **4종 탄약** — 원작처럼 피해 특성이 다른 **포탄**(선체), **사슬탄**(돛), **유산탄**(선원), **폭발탄**(중형·단사거리).
- 🗺️ **직접 항해하는 먼바다** — 세계 지도가 실제 3D 바다입니다. 4개 국가와 해적 소굴이 나눠 가진 7개 섬 사이로 배를 몰 수 있습니다. 항해 중 날짜가 지나고(선원 임금, 식량 소모), 지평선의 다른 돛이 적이면 전투로 이어집니다. `M` — 양피지 해도, `E` — 섬에 닻 내리기, `Enter` — 직접 조타.
- 💰 **살아있는 경제** — 16종 교역품. 식민지마다 수출품(저렴)과 수입품(고가)이 다르고, 재고 수준과 교역 스킬에 따라 가격이 변합니다.
- ⚔️ **RPG 시스템** — 10개 스킬(통솔, 펜싱, 항해, 명중, 대포, 백병전, 방어, 수리, 교역, 행운), 레벨, 스킬 포인트.
- 🏴 **국가와 평판** — 잉글랜드, 프랑스, 스페인, 네덜란드, 해적. 전쟁, 격침에 따른 외교적 대가, 적대적 선장에게 닫히는 항구.
- 📜 **총독 퀘스트** — 화물 배송, 해적 토벌, 승객 수송. 기한과 평판 페널티.
- 🛠️ **항구 생활** — 시장, 11개 선급(타르탄 → 맨 오브 워)을 다루는 조선소와 교체(trade-in), 선원 고용, 수리.
- 💾 **세이브** — JSON 세이브, 항해 후 자동 저장.
- 🏘️ **걸어다닐 수 있는 3D 항구 마을** — 섬마다 다른 거리 배치와 날씨. 선술집, 상점, 조선소, 총독부 등 **모든 건물에 입장 가능**하며 NPC와 대화할 수 있습니다.
- 🌗 **낮과 밤 순환** — 마을, 바다, 전투에서 태양이 움직입니다.
- ⚔️ **3인칭 백병전** — 적 갑판으로 건너가 커틀러스로 싸우고, 이기면 노획합니다.
- 🎵 **오케스트라 사운드트랙** — Suno로 작곡된 메인 테마, 해전곡, 뱃노래.

## 조작법 (해전)

| 키 | 동작 |
|-----|--------|
| `W` / `S` | 돛 올리기 / 거두기 |
| `A` / `D` | 키 좌 / 우 |
| `Q` / `E` | 좌현 / 우현 일제사격 |
| `R` | 탄약 종류 전환 |
| `B` | 백병전 돌입 (먼저 바짝 붙을 것!) |
| 우클릭 드래그 | 카메라 회전 |
| 휠 | 줌 |

먼바다: `W/S/A/D` 항해, `M` 해도, `E` 닻 내리기, `Enter` 정박/조타.
마을: `WASD` 걷기, `E` 건물 입장/승선, `Tab` 항구 메뉴.

## 한국어판 안내

- 게임 내 모든 UI 텍스트(메뉴, 항구, 시장, 조선소, 총독 퀘스트, 해전 HUD, 백병전, 로그 메시지), 교역품·선급·스킬·국가·섬 이름을 한국어로 번역했습니다.
- 한글 표시를 위해 **나눔고딕(NanumGothic, SIL Open Font License)** 폰트를 추가했습니다. 2D UI뿐 아니라 3D 세계의 간판·섬 이름(Label3D)에도 적용됩니다.
- 게임 ID·내부 키·원작자 표기는 원본을 유지했습니다. 음악·이미지 등 에셋은 원본과 동일합니다.
- 번역 후 원본의 테스트(10개 스위트, 1,309개 검증)와 장면 스모크 테스트를 그대로 통과했고, Godot 4.7 웹 익스포트가 정상적으로 완료됨을 확인했습니다.

## 실행 / 빌드

[Godot 4.x](https://godotengine.org/download)만 있으면 됩니다(무료, ~100MB).

```bash
godot --headless --path . -s tests/run_tests.gd     # 코어 단위 테스트
godot --headless --path . -s tests/smoke_scenes.gd  # 장면 스모크 테스트
godot --headless --path . --export-release "Web" build/web/index.html  # 웹 빌드
```

에디터에서 폴더를 열고 **F5**를 눌러도 됩니다.

## 프로젝트 구조

```
core/      게임 로직 — 장면 의존 없음, 전부 단위 테스트됨
tests/     헤드리스 테스트 프레임워크 + 단위/스모크 테스트
scenes/    메인 메뉴, 먼바다(세계 지도), 항구 마을, 항구, 해전, 백병전
scripts/   장면 스크립트 + Game 오토로드(장면 라우팅)
assets/    선박, 소품, 건물, 인물(glTF), PBR 텍스처, HDRI 하늘, 음악
tools/     Poly Haven 수집기, Blender 임포트 스크립트 등
docs/      원본 README의 스크린샷
```

## 라이선스

[MIT](LICENSE) — 원본 저장소의 라이선스를 그대로 따릅니다.
나눔고딕 폰트는 [SIL Open Font License](assets/fonts/OFL.txt)로 배포됩니다.

---

*This is the Korean localization fork. For the original English README, see [README.en.md](README.en.md). Original project: [Elkhan-Isayev/corsairs](https://github.com/Elkhan-Isayev/corsairs).*
