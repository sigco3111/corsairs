## Port: "항구", "시장", "조선소" and "선장" tabs.
extends Control

const World := preload("res://core/world.gd")
const Goods := preload("res://core/goods.gd")
const ShipTypes := preload("res://core/ship_types.gd")
const Ammo := preload("res://core/ammo.gd")
const Character := preload("res://core/character.gd")

var _tabs: TabContainer
var _header: Label
var _quest_offers: Array = []


func _ready() -> void:
	Music.play_theme()
	var bg := ColorRect.new()
	bg.color = Color("1b2a38")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	# Painted harbor behind the panels.
	var art := TextureRect.new()
	art.texture = load("res://assets/art/port_harbor.jpg")
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(art)
	var shade := ColorRect.new()
	shade.color = Color(0.04, 0.07, 0.11, 0.35)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shade)

	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 16
	root.offset_right = -16
	root.offset_top = 10
	root.offset_bottom = -10
	add_child(root)

	# Header row: status text + an always-visible exit button.
	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 16)
	root.add_child(header_row)

	_header = Label.new()
	_header.add_theme_font_size_override("font_size", 22)
	_header.add_theme_color_override("font_color", Color("e8c872"))
	_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_child(_header)

	var exit_btn := Button.new()
	exit_btn.text = "마을로 돌아가기 (Esc)"
	exit_btn.pressed.connect(func(): Game.goto_port())
	header_row.add_child(exit_btn)

	_tabs = TabContainer.new()
	_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color(0.06, 0.1, 0.15, 0.86)
	panel.set_corner_radius_all(6)
	panel.set_content_margin_all(14)
	_tabs.add_theme_stylebox_override("panel", panel)
	root.add_child(_tabs)

	_generate_quest_offers()
	_rebuild()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_ESCAPE:
		Game.goto_port()


func _island() -> Dictionary:
	return World.island(Game.state.current_island)


func _generate_quest_offers() -> void:
	_quest_offers = []
	var s = Game.state
	for i in 3:
		_quest_offers.append(s.quests.generate_offer(s.current_island, s.day, s.rng))


func _rebuild() -> void:
	var s = Game.state
	var isl := _island()
	_header.text = "%s - %s 식민지 | %d일차 | %d골드 | %s: 선체 %d%%, 선원 %d/%d" % [
		isl["name"], World.NATIONS[isl["nation"]]["name"], s.day, s.character.gold,
		s.ship.custom_name, int(s.ship.hull_frac() * 100), s.ship.crew, s.ship.spec()["max_crew"]]

	var current_tab := _tabs.current_tab
	# Detach old tabs immediately so new ones don't get @-mangled names.
	for c in _tabs.get_children():
		_tabs.remove_child(c)
		c.queue_free()
	_tabs.add_child(_with_portrait(_build_port_tab(), "governor", "총독"))
	_tabs.add_child(_with_portrait(_build_market_tab(), "merchant", "상인"))
	_tabs.add_child(_with_portrait(_build_shipyard_tab(), "shipwright", "조선공"))
	_tabs.add_child(_with_portrait(_build_captain_tab(), "captain", "선장 " + s.character.char_name))
	for i in 4:
		_tabs.set_tab_title(i, ["항구", "시장", "조선소", "선장"][i])
	if Game.port_tab >= 0:
		_tabs.current_tab = Game.port_tab
		Game.port_tab = -1
	elif current_tab >= 0 and current_tab < 4:
		_tabs.current_tab = maxi(current_tab, 0)


## The tab's content with a painted portrait of whoever you deal with there.
func _with_portrait(content: Control, who: String, caption: String) -> Control:
	var row := HBoxContainer.new()
	row.name = content.name
	row.add_theme_constant_override("separation", 18)
	var col := VBoxContainer.new()
	row.add_child(col)
	var frame := PanelContainer.new()
	var border := StyleBoxFlat.new()
	border.bg_color = Color(0.1, 0.07, 0.04)
	border.border_color = Color("c9a54f")
	border.set_border_width_all(3)
	border.set_content_margin_all(3)
	frame.add_theme_stylebox_override("panel", border)
	col.add_child(frame)
	var pic := TextureRect.new()
	pic.texture = load("res://assets/art/portrait_%s.jpg" % who)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	pic.custom_minimum_size = Vector2(210, 210)
	frame.add_child(pic)
	var name_lbl := _label(caption, "e8c872")
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(name_lbl)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(content)
	return row


func _scroll_tab(title: String) -> ScrollContainer:
	var sc := ScrollContainer.new()
	sc.name = title
	return sc


func _label(text: String, color := "cfe3f5") -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_color_override("font_color", Color(color))
	return l


# --- Port tab ---

func _build_port_tab() -> Control:
	var sc := _scroll_tab("항구")
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 10)
	sc.add_child(box)
	var s = Game.state
	var isl := _island()

	var rep: int = s.world.reputation(isl["nation"])
	box.add_child(_label("당신에 대한 %s의 태도: %d" % [World.NATIONS[isl["nation"]]["name"], rep],
		"81c784" if rep >= 0 else "e57373"))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	box.add_child(row)

	var town := Button.new()
	town.text = "마을로"
	town.pressed.connect(func(): Game.goto_port())
	row.add_child(town)

	var sail := Button.new()
	sail.text = "%s에서 출항 - 먼바다로" % isl["name"]
	sail.pressed.connect(func(): Game.goto_open_sea_from_port())
	row.add_child(sail)

	var hire := Button.new()
	hire.text = "선원 10명 고용 (%d골드)" % (10 * 20)
	hire.pressed.connect(func():
		if not Game.state.hire_crew(10):
			OS.alert("골드 또는 선원 숙소가 부족합니다.", "선술집")
		_rebuild())
	row.add_child(hire)

	var repair := Button.new()
	repair.text = "선박 수리"
	repair.pressed.connect(func():
		var cost: int = Game.state.repair_ship_at_shipyard()
		if cost < 0:
			OS.alert("수리 비용이 부족합니다.", "조선소")
		elif cost == 0:
			OS.alert("선박 상태가 완벽합니다.", "조선소")
		_rebuild())
	row.add_child(repair)

	var save_btn := Button.new()
	save_btn.text = "게임 저장"
	save_btn.pressed.connect(func(): Game.save_game(); OS.alert("저장되었습니다.", "Corsairs"))
	row.add_child(save_btn)

	box.add_child(HSeparator.new())
	box.add_child(_label("· 총독의 제안 ·", "e8c872"))
	for offer in _quest_offers:
		var qrow := HBoxContainer.new()
		qrow.add_theme_constant_override("separation", 10)
		box.add_child(qrow)
		var desc := "%s | 보상 %d골드 | 기한: %d일차" % [offer["title"], offer["reward"], offer["deadline_day"]]
		if offer["kind"] == "deliver":
			desc += " | 화물: %s ×%d" % [Goods.get_type(offer["goods"])["name"], offer["units"]]
		qrow.add_child(_label(desc))
		var take := Button.new()
		take.text = "수락"
		take.pressed.connect(func():
			if Game.state.quests.accept(offer, Game.state.ship):
				_quest_offers.erase(offer)
			else:
				OS.alert("선창 공간이 부족합니다!", "총독")
			_rebuild())
		qrow.add_child(take)

	box.add_child(HSeparator.new())
	box.add_child(_label("· 진행 중인 퀘스트 ·", "e8c872"))
	if s.quests.active.is_empty():
		box.add_child(_label("진행 중인 퀘스트가 없습니다."))
	for q in s.quests.active:
		box.add_child(_label("• %s (기한 %d일차, %d골드)" % [q["title"], q["deadline_day"], q["reward"]]))
	return sc


# --- Market tab ---

func _build_market_tab() -> Control:
	var sc := _scroll_tab("시장")
	var grid := GridContainer.new()
	grid.columns = 7
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 6)
	sc.add_child(grid)

	var s = Game.state
	var m = s.world.market(s.current_island)
	var trade: int = s.character.skill("trade")

	for h in ["품목", "재고", "구매가", "판매가", "보유", "", ""]:
		grid.add_child(_label(h, "e8c872"))

	for g in Goods.all_ids():
		var info := Goods.get_type(g)
		var in_hold: int = int(s.ship.cargo.get(g, 0))
		var is_export: bool = g in m.exports
		var is_import: bool = g in m.imports
		var name_color := "81c784" if is_export else ("e57373" if is_import else "cfe3f5")
		# Words, not arrow glyphs — the web build's font has no arrows.
		grid.add_child(_label(info["name"] + ("  (수출)" if is_export else ("  (수입)" if is_import else "")), name_color))
		grid.add_child(_label(str(m.stock.get(g, 0))))
		grid.add_child(_label("%d골드" % m.buy_price(g, trade)))
		grid.add_child(_label("%d골드" % m.sell_price(g, trade)))
		grid.add_child(_label(str(in_hold)))

		var buy := Button.new()
		buy.text = "10개 구매"
		buy.pressed.connect(func():
			if m.player_buy(g, 10, s.character, s.ship, trade) < 0:
				OS.alert("거래 불가: 골드, 재고 또는 선창 공간이 부족합니다.", "시장")
			_rebuild())
		grid.add_child(buy)

		var sell := Button.new()
		sell.text = "10개 판매"
		sell.disabled = in_hold < 10
		sell.pressed.connect(func():
			if m.player_sell(g, 10, s.character, s.ship, trade) < 0:
				OS.alert("보유한 화물이 그만큼 없습니다.", "시장")
			_rebuild())
		grid.add_child(sell)

	return sc


# --- Shipyard tab ---

func _build_shipyard_tab() -> Control:
	var sc := _scroll_tab("조선소")
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	sc.add_child(box)
	var s = Game.state
	var isl := _island()

	box.add_child(_label("· 탄약 (남은 선창: %d) ·" % s.ship.cargo_free(), "e8c872"))
	var arow := HBoxContainer.new()
	arow.add_theme_constant_override("separation", 10)
	box.add_child(arow)
	for a in Ammo.ORDER:
		var t := Ammo.get_type(a)
		var b := Button.new()
		b.text = "%s ×50 (%d골드) [보유 %d]" % [t["name"], t["price"] * 50, s.ship.ammo_stock.get(a, 0)]
		b.pressed.connect(func():
			if not Game.state.buy_ammo(a, 50, t["price"]):
				OS.alert("골드가 부족합니다.", "조선소")
			_rebuild())
		arow.add_child(b)

	box.add_child(HSeparator.new())
	box.add_child(_label("· 판매 중인 선박 (내 배는 교체 비용에 반영) ·", "e8c872"))
	var trade_in := int(s.ship.spec()["price"] * 0.5 * s.ship.hull_frac())
	box.add_child(_label("내 %s 교체 반영액: %d골드" % [s.ship.spec()["name"], trade_in]))

	for id in ShipTypes.available_for_shipyard(int(isl["tier"])):
		if id == s.ship.type_id:
			continue
		var t := ShipTypes.get_type(id)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		box.add_child(row)
		row.add_child(_label("%s (등급 %d): 선체 %d, 함포 %d, 선창 %d, 속도 %.1f - %d골드" % [
			t["name"], t["rank"], t["hull"], t["cannons"], t["cargo"], t["base_speed"], t["price"]]))
		var buy := Button.new()
		var to_pay := maxi(int(t["price"]) - trade_in, 0)
		buy.text = "구매 (%d골드 지불)" % to_pay
		buy.disabled = not s.character.can_afford(to_pay)
		buy.pressed.connect(func():
			if Game.state.buy_ship(id):
				OS.alert("새 %s 취득을 축하합니다!" % t["name"], "조선소")
			_rebuild())
		row.add_child(buy)
	return sc


# --- Captain tab ---

func _build_captain_tab() -> Control:
	var sc := _scroll_tab("선장")
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	sc.add_child(box)
	var c = Game.state.character

	box.add_child(_label("%s, 레벨 %d (%s)" % [c.char_name, c.level, World.NATIONS[c.nation]["name"]], "e8c872"))
	box.add_child(_label("XP: %d / %d | 남은 스킬 포인트: %d" % [c.xp, Character.xp_for_level(c.level), c.free_skill_points]))
	box.add_child(HSeparator.new())

	for skill_id in Character.SKILLS:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		box.add_child(row)
		var name_lbl := _label(Character.SKILL_NAMES[skill_id])
		name_lbl.custom_minimum_size = Vector2(130, 0)
		row.add_child(name_lbl)
		# Segmented bar drawn with rects: the web build's font has no
		# block-element glyphs, so no text-art bars.
		var pips := HBoxContainer.new()
		pips.add_theme_constant_override("separation", 3)
		pips.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(pips)
		for p in Character.MAX_SKILL:
			var pip := ColorRect.new()
			pip.custom_minimum_size = Vector2(16, 12)
			pip.color = Color("e8c872") if p < c.skill(skill_id) else Color("3a4657")
			pips.add_child(pip)
		row.add_child(_label(str(c.skill(skill_id))))
		if c.free_skill_points > 0 and c.skill(skill_id) < Character.MAX_SKILL:
			var plus := Button.new()
			plus.text = "+"
			plus.pressed.connect(func(): c.raise_skill(skill_id); _rebuild())
			row.add_child(plus)

	box.add_child(HSeparator.new())
	box.add_child(_label("· 각국과의 관계 ·", "e8c872"))
	for n in World.NATIONS:
		var rep: int = Game.state.world.reputation(n)
		box.add_child(_label("%s: %d" % [World.NATIONS[n]["name"], rep],
			"81c784" if rep >= 0 else "e57373"))
	return sc
