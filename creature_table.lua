creature.tbl = {}

creature.ratio = {}
creature.ratio[1] = {10, 9, 8, 7, 6, 5, 4, 3, 2, 1}
creature.ratio[2] = {2, 4, 5, 8, 10, 10, 8, 4, 6, 2}
creature.ratio[3] = {0, 0, 1, 2, 3, 4, 5, 6, 7, 8}
creature.lst = {}
creature.lst[1] = {"grass", "mushroom", "tree", "flower", "lichen"}
creature.lst[2] = {"rat", "rabbit", "chicken", "slug"}
creature.lst[3] = {"snake", "wolf", "maneater"}

creature.idtoindex = {}
creature.idtoindex["grass"] = 1
creature.idtoindex["mushroom"] = 2
creature.idtoindex["tree"] = 3
creature.idtoindex["flower"] = 4
creature.idtoindex["lichen"] = 5
creature.idtoindex["rat"] = 6
creature.idtoindex["rabbit"] = 7
creature.idtoindex["chicken"] = 8
creature.idtoindex["slug"] = 9
creature.idtoindex["snake"] = 10
creature.idtoindex["wolf"] = 11
creature.idtoindex["maneater"] = 12
creature.idtoindex["dhole_head"] = 13
creature.idtoindex["slime"] = 14
creature.idtoindex["hador"] = 15
creature.idtoindex["powerlichen"] = 16
creature.idtoindex["vorpalrabbit"] = 17
creature.idtoindex["dhole_body"] = 18

creature.tbl[1] = {}
creature.tbl[1].id = "grass"
creature.tbl[1].name = "풀"
creature.tbl[1].speed = 100
creature.tbl[1].hp = 3
creature.tbl[1].attack = 1
creature.tbl[1].defence = 0
creature.tbl[1].agility = 0
creature.tbl[1].special = {"noattack"}
creature.tbl[1].movement = "static"

creature.tbl[2] = {}
creature.tbl[2].id = "mushroom"
creature.tbl[2].name = "버섯"
creature.tbl[2].speed = 80
creature.tbl[2].hp = 5
creature.tbl[2].attack = 1
creature.tbl[2].agility = 3
creature.tbl[2].movement = "chase"

creature.tbl[3] = {}
creature.tbl[3].id = "tree"
creature.tbl[3].name = "거동나무"
creature.tbl[3].speed = 80
creature.tbl[3].hp = 6
creature.tbl[3].attack = 2
creature.tbl[3].agility = 3
creature.tbl[3].movement = "chase"

creature.tbl[4] = {}
creature.tbl[4].id = "flower"
creature.tbl[4].name = "황꽃"
creature.tbl[4].speed = 100
creature.tbl[4].hp = 3
creature.tbl[4].attack = 1
creature.tbl[4].agility = 0
creature.tbl[4].special = {"noattack"}
creature.tbl[4].movement = "static"

creature.tbl[5] = {}
creature.tbl[5].id = "lichen"
creature.tbl[5].name = "이끼"
creature.tbl[5].speed = 100
creature.tbl[5].hp = 4
creature.tbl[5].attack = 1
creature.tbl[5].agility = 0
creature.tbl[5].movement = "static"

creature.tbl[6] = {}
creature.tbl[6].id = "rat"
creature.tbl[6].name = "쥐"
creature.tbl[6].speed = 100
creature.tbl[6].hp = 6
creature.tbl[6].attack = 2
creature.tbl[6].agility = 4
creature.tbl[6].movement = "chase"

creature.tbl[7] = {}
creature.tbl[7].id = "rabbit"
creature.tbl[7].name = "토끼"
creature.tbl[7].speed = 120
creature.tbl[7].hp = 7
creature.tbl[7].attack = 1
creature.tbl[7].agility = 5 
creature.tbl[7].movement = "chase"

creature.tbl[8] = {}
creature.tbl[8].id = "chicken"
creature.tbl[8].name = "닭"
creature.tbl[8].speed = 120
creature.tbl[8].hp = 7
creature.tbl[8].attack = 1
creature.tbl[8].agility = 4
creature.tbl[8].movement = "run"

creature.tbl[9] = {}
creature.tbl[9].id = "slug"
creature.tbl[9].name = "민달팽이"
creature.tbl[9].speed = 25
creature.tbl[9].hp = 8
creature.tbl[9].attack = 4
creature.tbl[9].agility = 3
creature.tbl[9].special = {"scream"}
creature.tbl[9].movement = "chase"

creature.tbl[10] = {}
creature.tbl[10].id = "snake"
creature.tbl[10].name = "뱀"
creature.tbl[10].speed = 100
creature.tbl[10].hp = 9
creature.tbl[10].attack = 5
creature.tbl[10].agility = 6
creature.tbl[10].movement = "chase"

creature.tbl[11] = {}
creature.tbl[11].id = "wolf"
creature.tbl[11].name = "늑대"
creature.tbl[11].speed = 100
creature.tbl[11].hp = 12
creature.tbl[11].attack = 4
creature.tbl[11].agility = 5
creature.tbl[11].movement = "chase"

creature.tbl[12] = {}
creature.tbl[12].id = "maneater"
creature.tbl[12].name = "식인식물"
creature.tbl[12].speed = 100
creature.tbl[12].hp = 7
creature.tbl[12].attack = 3
creature.tbl[12].special = {"hold"}
creature.tbl[12].agility = 3
creature.tbl[12].movement = "static"

creature.tbl[13] = {}
creature.tbl[13].id = "dhole_head"
creature.tbl[13].name = "드홀"
creature.tbl[13].speed = 150
creature.tbl[13].hp = 20
creature.tbl[13].attack = 4
creature.tbl[13].special = {"seethrough", "dig"}
creature.tbl[13].agility = 0
creature.tbl[13].movement = "chase"

creature.tbl[18] = {}
creature.tbl[18].id = "dhole_body"
creature.tbl[18].name = "드홀"
creature.tbl[18].speed = 150
creature.tbl[18].hp = 20
creature.tbl[18].attack = 4
creature.tbl[18].special = {"seethrough", "dig", "noattack"}
creature.tbl[18].agility = 0
creature.tbl[18].movement = "chase"

creature.tbl[14] = {}
creature.tbl[14].id = "slime"
creature.tbl[14].name = "슬라임"
creature.tbl[14].speed = 200
creature.tbl[14].hp = 10
creature.tbl[14].attack = 6
creature.tbl[14].special = {"multiply"}
creature.tbl[14].agility = 2
creature.tbl[14].movement = "intelligence"

creature.tbl[15] = {}
creature.tbl[15].id = "hador"
creature.tbl[15].name = "하도르"
creature.tbl[15].speed = 100
creature.tbl[15].hp = 15
creature.tbl[15].attack = 5
creature.tbl[15].special = {"magic", "seethrough"}
creature.tbl[15].agility = 6
creature.tbl[15].movement = "intelligence"

creature.tbl[16] = {}
creature.tbl[16].id = "powerlichen"
creature.tbl[16].name = "힘쎈 이끼"
creature.tbl[16].speed = 200
creature.tbl[16].hp = 10
creature.tbl[16].attack = 3
creature.tbl[16].agility = 00
creature.tbl[16].movement = "static"

creature.tbl[17] = {}
creature.tbl[17].id = "vorpalrabbit"
creature.tbl[17].name = "보팔 래빗"
creature.tbl[17].speed = 300
creature.tbl[17].hp = 7
creature.tbl[17].attack = 1
creature.tbl[17].agility = 5
creature.tbl[17].movement = "chase"