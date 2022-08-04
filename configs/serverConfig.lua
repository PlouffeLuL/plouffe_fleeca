Fle = {}

Fle.Utils = {
  ped = 0,
  pedCoords = vector3(0,0,0)
}

Fle.Trolley = {
  cash = {trolley = "hei_prop_hei_cash_trolly_01", prop = "hei_prop_heist_cash_pile", empty = "hei_prop_hei_cash_trolly_03"},
  gold = {trolley = "ch_prop_gold_trolly_01a", prop = "ch_prop_gold_bar_01a", empty = "hei_prop_hei_cash_trolly_03"},
  diamond = {trolley = "ch_prop_diamond_trolly_01a", prop = "ch_prop_vault_dimaondbox_01a", empty = "hei_prop_hei_cash_trolly_03"}
}

Fle.Banks = {
  fleeca_vinewood = {
    maxMoney = 200000,
    trolleySpawns = {
      entry = {
        coords = vector3(315.19866821289,-284.79304321289,53.15),
        rotation = vector3(0.0,-0.0,69.520000000001)
      },
      back = {
        isExtra = true,
        coords = vector3(313.71292602539,-289.46371948242,53.15),
        rotation = vector3(0.0,-0.0,-20.21)
      },
      side = {
        isExtra = true,
        coords = vector3(311.49915161133,-287.29024047852,53.15),
        rotation = vector3(0.0,-0.0,-35.7)
      }
    },

		coords = {
      bank = {
        isZone = true,
        zMax = 58.0,
        zMin = 52.0,
        params = {zone = "fleeca_vinewood"},
        coords = {
          vector3(329.56842041016, -281.23577880859, 54.166728973389),
          vector3(299.70465087891, -270.14297485352, 54.004661560059),
          vector3(283.41302490234, -313.2512512207, 50.556392669678),
          vector3(316.16482543945, -325.14694213867, 49.617500305176)
        },
        zoneMap = {
          inEvent = "plouffe_fleeca:inFleeca",
          outEvent = "plouffe_fleeca:exitFleeca"
        }
      },

      hacking = {
        coords = vector3(311.25067138672, -284.44207763672, 54.164836883545),
        distance = 0.5
      },
    },
	},

  fleeca_square = {
    maxMoney = 200000,
    trolleySpawns = {
      entry = {
        coords = vector3(150.94411193848,-1046.4409863281,28.359269180298),
        rotation = vector3(0.0,-0.0,69.58)
      },
      back = {
        isExtra = true,
        coords = vector3(149.49851196289,-1050.9338623047,28.35934928894),
        rotation = vector3(0.0,-0.0,-20.41)
      },
      side = {
        isExtra = true,
        coords = vector3(146.84432922363,-1049.7136425781,28.359297790527),
        rotation = vector3(0.0,-0.0,-36.8)
      }
    },

		coords = {
      bank = {
        isZone = true,
        zMax = 33.0,
        zMin = 26.9,
        params = {zone = "fleeca_square"},
        coords = {
          vector3(155.75927734375, -1039.0615234375, 29.368091583252),
          vector3(150.4774017334, -1053.4527587891, 29.368091583252),
          vector3(128.59782409668, -1044.01171875, 29.368091583252),
          vector3(133.82865905762, -1030.6197509766, 29.368091583252)

        },
        zoneMap = {
          inEvent = "plouffe_fleeca:inFleeca",
          outEvent = "plouffe_fleeca:exitFleeca"
        }
      },

      hacking = {
        coords = vector3(146.87002563477, -1046.0610351563, 29.368091583252),
        distance = 0.5
      },
    },
	},

  fleeca_centreville = {
    maxMoney = 200000,
    trolleySpawns = {
      entry = {
        coords = vector3(-349.76951416016,-55.640061950684,48.012979278564),
        rotation = vector3(0.0,-0.0,56.05)
      },
      back = {
        isExtra = true,
        coords = vector3(-351.16995239258,-60.075733947754,48.017842559814),
        rotation = vector3(0.0,-0.0,-32.5)
      },
      side = {
        isExtra = true,
        coords = vector3(-353.30269775391,-59.347711181641,48.017838745117),
        rotation = vector3(0.0,-0.0,-4.8)
      }
    },

		coords = {
      bank = {
        isZone = true,
        zMax = 51.8,
        zMin = 46.9,
        params = {zone = "fleeca_centreville"},
        coords = {
          vector3(-344.17129516602, -48.313407897949, 49.036796569824),
          vector3(-357.15158081055, -43.855445861816, 49.036804199219),
          vector3(-364.93585205078, -67.612617492676, 49.036804199219),
          vector3(-353.03408813477, -70.6494140625, 49.036804199219)

        },
        zoneMap = {
          inEvent = "plouffe_fleeca:inFleeca",
          outEvent = "plouffe_fleeca:exitFleeca"
        }
      },

      hacking = {
        coords = vector3(-353.86297607422, -55.289821624756, 49.036571502686),
        distance = 0.5
      },
    },
	},

  fleeca_vescpucci = {
    maxMoney = 200000,
    trolleySpawns = {
      entry = {
        coords = vector3(-1207.7253369141,-334.06261352539,36.762223510742),
        rotation = vector3(0.0,-0.0,95.640000000001)
      },
      back = {
        isExtra = true,
        coords = vector3(-1205.3674316406,-337.92830200195,36.762299804688),
        rotation = vector3(0.0,-0.0,43.8)
      },
      side = {
        isExtra = true,
        coords = vector3(-1208.4262207031,-338.63868408203,36.76229598999),
        rotation = vector3(0.0,-0.0,2.2)
      }
    },

		coords = {
      bank = {
        isZone = true,
        zMax = 42.8,
        zMin = 35.0,
        params = {zone = "fleeca_vescpucci"},
        coords = {
          vector3(-1207.3571777344, -322.83044433594, 37.843883514404),
          vector3(-1199.232421875, -338.93829345703, 37.617813110352),
          vector3(-1211.8404541016, -346.60357666016, 38.179077148438),
          vector3(-1220.4462890625, -329.64782714844, 37.55982208252)
        },
        zoneMap = {
          inEvent = "plouffe_fleeca:inFleeca",
          outEvent = "plouffe_fleeca:exitFleeca"
        }
      },

      hacking = {
        coords = vector3(-1210.8081054688, -336.5627746582, 37.781047821045),
        distance = 0.5
      },
    },
	},

  fleeca_beach = {
    maxMoney = 200000,
    trolleySpawns = {
      entry = {
        coords = vector3(-2957.3504882813,485.7118347168,14.670270606995),
        rotation = vector3(0.0,-0.0,168.07)
      },
      back = {
        isExtra = true,
        coords = vector3(-2952.7583496094,485.67016601563,14.670370742798),
        rotation = vector3(0.0,-0.0,66.8)
      },
      side = {
        isExtra = true,
        coords = vector3(-2953.1444335937,482.78106689453,14.670319244385),
        rotation = vector3(0.0,-0.0,76.6)
      }
    },

		coords = {
      bank = {
        isZone = true,
        zMax = 19.5,
        zMin = 12.9,
        params = {zone = "fleeca_beach"},
        coords = {
          vector3(-2965.9877929688, 487.77374267578, 15.468698501587),
          vector3(-2947.7585449219, 486.88027954102, 15.463475227356),
          vector3(-2948.4829101563, 472.30804443359, 15.454298019409),
          vector3(-2966.9689941406, 472.65151977539, 15.559314727783)
        },
        zoneMap = {
          inEvent = "plouffe_fleeca:inFleeca",
          outEvent = "plouffe_fleeca:exitFleeca"
        }
      },

      hacking = {
        coords = vector3(-2956.5659179688, 481.70025634766, 15.697086334229),
        distance = 0.5
      },
    },
	},

  fleeca_sandy = {
    maxMoney = 200000,
    trolleySpawns = {
      entry = {
        coords = vector3(1172.1923095703,2711.5647949219,37.065222717285),
        rotation = vector3(0.0,-0.0,77.7)
      },
      back = {
        isExtra = true,
        coords = vector3(1171.9084472656,2716.3516210937,37.06529901123),
        rotation = vector3(0.0,-0.0,-195.43)
      },
      side = {
        isExtra = true,
        coords = vector3(1174.6758837891,2716.0259375,37.065260864258),
        rotation = vector3(0.0,-0.0,171.53)
      }
    },

		coords = {
      bank = {
        isZone = true,
        zMax = 42.5,
        zMin = 36.0,
        params = {zone = "fleeca_sandy"},
        coords = {
          vector3(1170.6267089844, 2702.6105957031, 38.176086425781),
          vector3(1170.6953125, 2717.8916015625, 37.981170654297),
          vector3(1181.3944091797, 2716.8615722656, 37.981170654297),
          vector3(1182.0384521484, 2702.4018554688, 37.981170654297)
        },
        zoneMap = {
          inEvent = "plouffe_fleeca:inFleeca",
          outEvent = "plouffe_fleeca:exitFleeca"
        }
      },

      hacking = {
        coords = vector3(1176.0322265625, 2712.8576660156, 38.08805847168),
        distance = 0.5
      },
    },
	}
}