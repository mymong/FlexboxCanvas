//
//  UIColor+FCColor.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/29.
//

#import "UIColor+FCColor.h"
#import "FCSeparators.h"

@implementation UIColor (FCColor)

- (NSString *)fc_hexString {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    if (a == 1) {
        return [NSString stringWithFormat:@"#%02X%02X%02X", (unsigned int)(r * 0xFF), (unsigned int)(g * 0xFF), (unsigned int)(b * 0xFF)];
    } else {
        return [NSString stringWithFormat:@"#%02X%02X%02X%@%g", (unsigned int)(r * 0xFF), (unsigned int)(g * 0xFF), (unsigned int)(b * 0xFF), FCStructComponentSeparator, a];
    }
}

- (NSString *)fc_hexStringWithAlpha {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [NSString stringWithFormat:@"#%02X%02X%02X%@%g", (unsigned int)(r * 0xFF), (unsigned int)(g * 0xFF), (unsigned int)(b * 0xFF), FCStructComponentSeparator, a];
}

- (NSString *)fc_hexStringWithoutAlpha {
    CGFloat r, g, b;
    [self getRed:&r green:&g blue:&b alpha:NULL];
    return [NSString stringWithFormat:@"#%02X%02X%02X", (unsigned int)(r * 0xFF), (unsigned int)(g * 0xFF), (unsigned int)(b * 0xFF)];
}

+ (instancetype)fc_colorWithString:(NSString *)str {
    if (!str || ![str isKindOfClass:NSString.class] || 0 == str.length) {
        return nil;
    }
    
    NSArray<NSString *> *comps = [str componentsSeparatedByString:FCStructComponentSeparator];
    NSString *name = [comps[0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    
    //获取十六进制颜色, eg:"#FFCC88,0.8"
    if ([name hasPrefix:@"#"] && name.length >= 7) {
        NSString *RR = [str substringWithRange:NSMakeRange(1, 2)];
        NSString *GG = [str substringWithRange:NSMakeRange(3, 2)];
        NSString *BB = [str substringWithRange:NSMakeRange(5, 2)];
        unsigned int r = 0, g = 0, b = 0;
        if ([[NSScanner scannerWithString:RR] scanHexInt:&r] &&
            [[NSScanner scannerWithString:GG] scanHexInt:&g] &&
            [[NSScanner scannerWithString:BB] scanHexInt:&b])
        {
            CGFloat alpha = 1; float a = 1;
            if (comps.count > 1 && [[NSScanner scannerWithString:comps[1]] scanFloat:&a] && a >= 0 && a < 1) {
                alpha = a;
            }
            return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
        }
    }
    
    //获取RGB颜色，eg:"128, 30, 255, 0.8"
    if (comps.count >= 3) {
        int r = 0, g = 0, b = 0;
        if ([[NSScanner scannerWithString:comps[0]] scanInt:&r] &&
            [[NSScanner scannerWithString:comps[1]] scanInt:&g] &&
            [[NSScanner scannerWithString:comps[2]] scanInt:&b] &&
            r >=0 && g >= 0 && b >= 0)
        {
            CGFloat alpha = 1; float a = 1;
            if (comps.count > 3 && [[NSScanner scannerWithString:comps[3]] scanFloat:&a] && a >= 0 && a < 1) {
                alpha = a;
            }
            return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
        }
    }
    
    //颜色名称，eg:"red,0.8"
    if (name.length > 0) {
        UIColor *color = nil;
        
        //系统命名的颜色
        //black, darkGray, lightGray, white, gray, red, green, blue, cyan, yellow, magenta, orange, purple, brown, clear
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", name]);
        if ([UIColor respondsToSelector:sel]) {
            color = [UIColor performSelector:sel];
        }
        
        //自定义名称颜色
        if (!color) {
            NSString *value = [self fc_hexStringsByNames][name];
            if (value) {
                color = [self fc_colorWithString:value];
            }
        }
        
        if (color) {
            if (comps.count > 1) {
                float a = 1;
                if ([[NSScanner scannerWithString:comps[1]] scanFloat:&a] && a >= 0 && a < 1) {
                    color = [color colorWithAlphaComponent:a];
                }
            }
            return color;
        }
    }
    
    return nil;
}

+ (NSDictionary *)fc_hexStringsByNames {
    static NSDictionary *colors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //https://www.colorhexa.com/color-names
        colors = @{ @"flame":@"#e25822", @"ao":@"#008000", @"cherryBlossomPink":@"#ffb7c5", @"lavenderGray":@"#c4c3d0", @"goldenYellow":@"#ffdf00", @"brandeisBlue":@"#0070ff", @"dollarBill":@"#85bb65", @"mantis":@"#74c365", @"pinkFlamingo":@"#fc74fd", @"fireEngineRed":@"#ce2029", @"darkPastelBlue":@"#779ecb", @"payneGrey":@"#536878", @"lightPink":@"#ffb6c1", @"ivory":@"#fffff0", @"electricCyan":@"#00ffff", @"deepPeach":@"#ffcba4", @"cornflowerBlue":@"#6495ed", @"deepMagenta":@"#cc00cc", @"cgBlue":@"#007aa5", @"persianPink":@"#f77fbe", @"sunsetOrange":@"#fd5e53", @"warmBlack":@"#004242", @"asparagus":@"#87a96b", @"roseTaupe":@"#905d5d", @"mediumSeaGreen":@"#3cb371", @"darkPastelRed":@"#c23b22", @"moccasin":@"#faebd7", @"sienna":@"#882d17", @"ecru":@"#c2b280", @"almond":@"#efdecd", @"crimsonRed":@"#990000", @"darkSlateGray":@"#2f4f4f", @"slateGray":@"#708090", @"darkOrchid":@"#9932cc", @"flax":@"#eedc82", @"antiFlashWhite":@"#f2f3f4", @"antiqueFuchsia":@"#915c83", @"persianOrange":@"#d99058", @"carolinaBlue":@"#99badd", @"violetBlue":@"#324ab2", @"darkKhaki":@"#bdb76b", @"turquoiseBlue":@"#00ffef", @"papayaWhip":@"#ffefd5", @"cerulean":@"#007ba7", @"deepCarrotOrange":@"#e9692c", @"paleCopper":@"#da8a67", @"outerSpace":@"#414a4c", @"aureolin":@"#fdee00", @"mintCream":@"#f5fffa", @"turquoiseGreen":@"#a0d6b4", @"vividTangerine":@"#ffa089", @"coralRed":@"#ff4040", @"venetianRed":@"#c80815", @"mediumSpringBud":@"#c9dc87", @"bubbles":@"#e7feff", @"fuchsiaPink":@"#ff77ff", @"harlequin":@"#3fff00", @"steelBlue":@"#4682b4", @"mauvelous":@"#ef98aa", @"paleLavender":@"#dcd0ff", @"skobeloff":@"#007474", @"jasmine":@"#f8de7e", @"tomato":@"#ff6347", @"lincolnGreen":@"#195905", @"floralWhite":@"#fffaf0", @"peachPuff":@"#ffdab9", @"oldMauve":@"#673147", @"purplePizzazz":@"#fe4eda", @"robin'sEggBlue":@"#1fcecb", @"stilDeGrainYellow":@"#fada5e", @"smokyBlack":@"#100c08", @"hookerGreen":@"#49796b", @"smalt":@"#003399", @"pink":@"#ffc0cb", @"lavenderMist":@"#e6e6fa", @"earthYellow":@"#e1a95f", @"purpleTaupe":@"#50404d", @"azureMist/Web":@"#f0ffff", @"coolGrey":@"#8c92ac", @"azure":@"#007fff", @"coral":@"#ff7f50", @"verdigris":@"#43b3ae", @"electricLavender":@"#f4bbff", @"islamicGreen":@"#009000", @"meatBrown":@"#e5b73b", @"airForceBlue":@"#5d8aa8", @"etonBlue":@"#96c8a2", @"mint":@"#3eb489", @"ballBlue":@"#21abcd", @"daffodil":@"#ffff31", @"carmine":@"#ff0040", @"forestGreen":@"#228b22", @"gray":@"#808080", @"paleVioletRed":@"#db7093", @"caféAuLait":@"#a67b5b", @"bluePurple":@"#8a2be2", @"cadmiumYellow":@"#fff600", @"blueBell":@"#a2a2d0", @"bleuDeFrance":@"#318ce7", @"brass":@"#b5a642", @"lightGray":@"#d3d3d3", @"electricUltramarine":@"#3f00ff", @"lemonChiffon":@"#fffacd", @"roseGold":@"#b76e79", @"mahogany":@"#c04000", @"sandDune":@"#967117", @"royalFuchsia":@"#ca2c92", @"darkTerraCotta":@"#cc4e5c", @"neonCarrot":@"#ffa343", @"powderBlue":@"#b0e0e6", @"rossoCorsa":@"#d40000", @"persianBlue":@"#1c39bb", @"carmineRed":@"#ff0038", @"jade":@"#00a86b", @"magicMint":@"#aaf0d1", @"phthaloBlue":@"#000f89", @"lawnGreen":@"#7cfc00", @"saddleBrown":@"#8b4513", @"paleCarmine":@"#af4035", @"topaz":@"#ffc87c", @"persianPlum":@"#701c1c", @"moonstoneBlue":@"#73a9c2", @"darkCoral":@"#cd5b45", @"heartGold":@"#808000", @"deepCarminePink":@"#ef3038", @"darkChestnut":@"#986960", @"goldenrod":@"#daa520", @"harvestGold":@"#da9100", @"copper":@"#b87333", @"vividBurgundy":@"#9f1d35", @"darkSpringGreen":@"#177245", @"linen":@"#faf0e6", @"pastelBrown":@"#836953", @"spiroDiscoBall":@"#0fc0fc", @"deepChampagne":@"#fad6a5", @"inchworm":@"#b2ec5d", @"fluorescentYellow":@"#ccff00", @"ube":@"#8878c3", @"bittersweet":@"#fe6f5e", @"cornsilk":@"#fff8dc", @"darkBlue":@"#00008b", @"snow":@"#fffafa", @"paleCornflowerBlue":@"#abcdef", @"uclaGold":@"#ffb300", @"paleBlue":@"#afeeee", @"brightPink":@"#ff007f", @"celadon":@"#ace1af", @"glaucous":@"#6082b6", @"alizarinCrimson":@"#e32636", @"red":@"#ff0000", @"lightCyan":@"#e0ffff", @"mistyRose":@"#ffe4e1", @"straw":@"#e4d96f", @"pearl":@"#eae0c8", @"lightCarminePink":@"#e66771", @"slateBlue":@"#6a5acd", @"jonquil":@"#fada5e", @"deepLilac":@"#9955bb", @"wine":@"#722f37", @"brightLavender":@"#bf94e4", @"redBrown":@"#a52a2a", @"apricot":@"#fbceb1", @"dandelion":@"#f0e130", @"carnationPink":@"#ffa6c9", @"goldenBrown":@"#996515", @"cerise":@"#de3163", @"atomicTangerine":@"#ff9966", @"mediumAquamarine":@"#66ddaa", @"puce":@"#cc8899", @"beaver":@"#9f8170", @"darkCandyAppleRed":@"#a40000", @"icterine":@"#fcf75e", @"chamoisee":@"#a0785a", @"halayàÚbe":@"#663854", @"laurelGreen":@"#a9ba9d", @"ceruleanBlue":@"#2a52be", @"darkSienna":@"#3c1414", @"redOrange":@"#ff5349", @"satinSheenGold":@"#cba135", @"beige":@"#f5f5dc", @"royalBlue":@"#4169e1", @"trolleyGrey":@"#808080", @"paleSilver":@"#c9c0bb", @"hanPurple":@"#5218fa", @"uscGold":@"#ffcc00", @"pinkSherbet":@"#f78fa7", @"vanilla":@"#f3e5ab", @"upMaroon":@"#7b1113", @"lemonLime":@"#bfff00", @"amaranth":@"#e52b50", @"seaGreen":@"#2e8b57", @"lilac":@"#c8a2c8", @"mediumSlateBlue":@"#7b68ee", @"rosePink":@"#ff66cc", @"ochre":@"#cc7722", @"patriarch":@"#800080", @"darkMagenta":@"#8b008b", @"oceanBoatBlue":@"#0077be", @"upForestGreen":@"#014421", @"white":@"#ffffff", @"lightSalmon":@"#ffa07a", @"electricYellow":@"#ffff00", @"limeGreen":@"#32cd32", @"hunterGreen":@"#355e3b", @"lavenderBlush":@"#fff0f5", @"lemon":@"#fff700", @"paleRobinEggBlue":@"#96ded1", @"sunglow":@"#ffcc33", @"darkTurquoise":@"#00ced1", @"zaffre":@"#0014a8", @"mediumVioletRed":@"#c71585", @"dodgerBlue":@"#1e90ff", @"ultramarine":@"#120a8f", @"darkMidnightBlue":@"#003366", @"darkElectricBlue":@"#536878", @"purpleMountainMajesty":@"#9678b6", @"dartmouthGreen":@"#00693e", @"mauveTaupe":@"#915f6d", @"deepJungleGreen":@"#004b49", @"persianRose":@"#fe28a2", @"napierGreen":@"#2a8000", @"fashionFuchsia":@"#f400a1", @"crimson":@"#dc143c", @"tawny":@"#cd5700", @"mediumTurquoise":@"#48d1cc", @"oldLace":@"#fdf5e6", @"bronze":@"#cd7f32", @"lightBlue":@"#add8e6", @"orchid":@"#da70d6", @"peach":@"#ffe5b4", @"outrageousOrange":@"#ff6e4a", @"pastelGreen":@"#77dd77", @"trueBlue":@"#0073cf", @"orangeRed":@"#ff4500", @"heliotrope":@"#df73ff", @"darkLavender":@"#734f96", @"umber":@"#635147", @"jungleGreen":@"#29ab87", @"deepCerise":@"#da3287", @"fluorescentPink":@"#ff1493", @"lightPastelPurple":@"#b19cd9", @"internationalOrange":@"#ff4f00", @"neonFuchsia":@"#fe59c2", @"antiqueBrass":@"#cd9575", @"electricGreen":@"#00ff00", @"purpleMountain'sMajesty":@"#9d81ba", @"lavenderBlue":@"#ccccff", @"veronica":@"#a020f0", @"otterBrown":@"#654321", @"grullo":@"#a99a86", @"cornflower":@"#9aceeb", @"desert":@"#c19a6b", @"smokeyTopaz":@"#933d41", @"fawn":@"#e5aa70", @"chartreuse":@"#7fff00", @"mikadoYellow":@"#ffc40c", @"babyPink":@"#f4c2c2", @"blueViolet":@"#8a2be2", @"juneBud":@"#bdda57", @"piggyPink":@"#fddde6", @"fieldDrab":@"#6c541e", @"fern":@"#71bc78", @"mediumPersianBlue":@"#0067a5", @"deepCoffee":@"#704241", @"majorelleBlue":@"#6050dc", @"hotMagenta":@"#ff1dce", @"tangelo":@"#f94d00", @"paleCerulean":@"#9bc4e2", @"liver":@"#534b4f", @"britishRacingGreen":@"#004225", @"paleRedViolet":@"#db7093", @"platinum":@"#e5e4e2", @"coquelicot":@"#ff3800", @"modeBeige":@"#967117", @"cinnamon":@"#d2691e", @"sandyBrown":@"#f4a460", @"sinopia":@"#cb410b", @"cinereous":@"#98817b", @"carminePink":@"#eb4c42", @"macaroniAndCheese":@"#ffbd88", @"vegasGold":@"#c5b358", @"cornellRed":@"#b31b1b", @"redViolet":@"#c71585", @"pistachio":@"#93c572", @"mediumTaupe":@"#674c47", @"royalAzure":@"#0038a8", @"zinnwalditeBrown":@"#2c1608", @"cocoaBrown":@"#d2691e", @"ginger":@"#b06500", @"raspberryGlace":@"#915f6d", @"canary":@"#ffff99", @"whiteSmoke":@"#f5f5f5", @"feldgrau":@"#4d5d53", @"frenchLilac":@"#86608e", @"pastelYellow":@"#fdfd96", @"cottonCandy":@"#ffbcd9", @"paleMagenta":@"#f984e5", @"bostonUniversityRed":@"#cc0000", @"desertSand":@"#edc9af", @"chocolate":@"#d2691e", @"darkLava":@"#483c32", @"iris":@"#5a4fcf", @"lavenderPink":@"#fbaed2", @"psychedelicPurple":@"#df00ff", @"maize":@"#fbec5d", @"flavescent":@"#f7e98e", @"indianRed":@"#cd5c5c", @"lapisLazuli":@"#26619c", @"timberwolf":@"#dbd7d2", @"midnightGreen":@"#004953", @"amethyst":@"#9966cc", @"darkPastelPurple":@"#966fd6", @"blizzardBlue":@"#ace5ee", @"lime":@"#bfff00", @"rufous":@"#a81c07", @"razzleDazzleRose":@"#ff33cc", @"orangePeel":@"#ff9f00", @"tigerEye":@"#e08d3c", @"richMaroon":@"#b03060", @"antiqueWhite":@"#faebd7", @"darkTan":@"#918151", @"vividCerise":@"#da1d81", @"classicRose":@"#fbcce7", @"lightApricot":@"#fdd5b1", @"sacramentoStateGreen":@"#00563f", @"manatee":@"#979aaa", @"operaMauve":@"#b784a7", @"palatinateBlue":@"#273be2", @"sandstorm":@"#ecd540", @"electricLime":@"#ccff00", @"lightBrown":@"#b5651d", @"dogwoodRose":@"#d71868", @"pansyPurple":@"#78184a", @"rackley":@"#5d8aa8", @"taupeGray":@"#8b8589", @"pumpkin":@"#ff7518", @"indigo":@"#4b0082", @"electricViolet":@"#8f00ff", @"mayaBlue":@"#73c2fb", @"ashGrey":@"#b2beb5", @"hollywoodCerise":@"#f400a1", @"tyrianPurple":@"#66023c", @"indianYellow":@"#e3a857", @"camouflageGreen":@"#78866b", @"tractorRed":@"#fd0e35", @"russet":@"#80461b", @"uaRed":@"#d9004c", @"lightFuchsiaPink":@"#f984ef", @"folly":@"#ff004f", @"aquamarine":@"#7fffd4", @"mediumSpringGreen":@"#00fa9a", @"lightGoldenrodYellow":@"#fafad2", @"cardinal":@"#c41e3a", @"frenchBlue":@"#0072bb", @"fernGreen":@"#4f7942", @"onyx":@"#0f0f0f", @"amber":@"#ffbf00", @"kellyGreen":@"#4cbb17", @"boysenberry":@"#873260", @"candyPink":@"#e4717a", @"coralPink":@"#f88379", @"pastelPink":@"#ffd1dc", @"tuftsBlue":@"#417dc1", @"mediumRedViolet":@"#bb3385", @"turkishRose":@"#b57281", @"mustard":@"#ffdb58", @"darkBrown":@"#654321", @"ultramarineBlue":@"#4166f5", @"blue":@"#0000ff", @"cadmiumRed":@"#e30022", @"wildWatermelon":@"#fc6c85", @"pakistanGreen":@"#006600", @"seaBlue":@"#006994", @"aurometalsaurus":@"#6e7f80", @"persianRed":@"#cc3333", @"wenge":@"#645452", @"copperRose":@"#996666", @"purple":@"#800080", @"burgundy":@"#800020", @"olive":@"#808000", @"blush":@"#de5d83", @"battleshipGrey":@"#848482", @"roseBonbon":@"#f9429e", @"darkPowderBlue":@"#003399", @"calPolyPomonaGreen":@"#1e4d2b", @"munsell":@"#f2f3f4", @"orange":@"#ffa500", @"darkByzantium":@"#5d3954", @"pinkPearl":@"#e7accf", @"darkSlateBlue":@"#483d8b", @"pastelGray":@"#cfcfc4", @"fulvous":@"#e48400", @"candyAppleRed":@"#ff0800", @"buff":@"#f0dc82", @"pear":@"#d1e231", @"androidGreen":@"#a4c639", @"pastelPurple":@"#b39eb5", @"mediumElectricBlue":@"#035096", @"flamingoPink":@"#fc8eac", @"lightCoral":@"#f08080", @"lightSkyBlue":@"#87cefa", @"frenchBeige":@"#a67b5b", @"richCarmine":@"#d70040", @"dukeBlue":@"#00009c", @"wildBlueYonder":@"#a2add0", @"palatinatePurple":@"#682860", @"turquoise":@"#30d5c8", @"brickRed":@"#cb4154", @"fluorescentOrange":@"#ffbf00", @"bananaMania":@"#fae7b5", @"lavenderIndigo":@"#9457eb", @"dimGray":@"#696969", @"darkViolet":@"#9400d3", @"shamrockGreen":@"#009e60", @"peridot":@"#e6e200", @"goldenPoppy":@"#fcc200", @"darkTaupe":@"#483c32", @"cherry":@"#de3163", @"black":@"#000000", @"pacificBlue":@"#1ca9c9", @"darkRed":@"#8b0000", @"unmellowYellow":@"#ffff66", @"silver":@"#c0c0c0", @"urobilin":@"#e1ad21", @"mediumBlue":@"#0000cd", @"paleAqua":@"#bcd4e6", @"darkGray":@"#a9a9a9", @"teaGreen":@"#d0f0c0", @"stormcloud":@"#008080", @"sandyTaupe":@"#967117", @"honeydew":@"#f0fff0", @"paleGoldenrod":@"#eee8aa", @"faluRed":@"#801818", @"champagne":@"#fad6a5", @"teal":@"#008080", @"electricIndigo":@"#6f00ff", @"royalPurple":@"#7851a9", @"bottleGreen":@"#006a4e", @"mangoTango":@"#ff8243", @"roseQuartz":@"#aa98a9", @"yellowGreen":@"#9acd32", @"periwinkle":@"#ccccff", @"glitter":@"#e6e8fa", @"brightMaroon":@"#c32148", @"lion":@"#c19a6b", @"lavenderMagenta":@"#ee82ee", @"blueGreen":@"#0d98ba", @"mediumJungleGreen":@"#1c352d", @"darkCerulean":@"#08457e", @"razzmatazz":@"#e3256b", @"fuchsia":@"#ff00ff", @"vividViolet":@"#9f00ff", @"cerisePink":@"#ec3b83", @"cobalt":@"#0047ab", @"awesome":@"#ff2052", @"electricCrimson":@"#ff003f", @"tuscanRed":@"#66424d", @"skyBlue":@"#87ceeb", @"melon":@"#fdbcb4", @"unitedNationsBlue":@"#5b92e5", @"deepSkyBlue":@"#00bfff", @"carrotOrange":@"#ed9121", @"persianIndigo":@"#32127a", @"cadmiumOrange":@"#ed872d", @"vermilion":@"#e34234", @"firebrick":@"#b22222", @"darkSalmon":@"#e9967a", @"mountainMeadow":@"#30ba8f", @"bondiBlue":@"#0095b6", @"uclaBlue":@"#536895", @"gainsboro":@"#dcdcdc", @"olivine":@"#9ab973", @"mediumTealBlue":@"#0054b4", @"schoolBusYellow":@"#ffd800", @"mossGreen":@"#addfad", @"rosyBrown":@"#bc8f8f", @"tealBlue":@"#367588", @"stizza":@"#990000", @"blanchedAlmond":@"#ffebcd", @"lightYellow":@"#ffffed", @"burntSienna":@"#e97451", @"lavenderRose":@"#fba0e3", @"greenBlue":@"#1164b4", @"lightTaupe":@"#b38b6d", @"ghostWhite":@"#f8f8ff", @"shamrock":@"#45cea2", @"babyBlue":@"#89cff0", @"cyan":@"#00ffff", @"cadmiumGreen":@"#006b3c", @"appleGreen":@"#8db600", @"paleBrown":@"#987654", @"darkTangerine":@"#ffa812", @"fuzzyWuzzy":@"#cc6666", @"darkGoldenrod":@"#b8860b", @"bulgarianRose":@"#480607", @"phlox":@"#df00ff", @"burntUmber":@"#8a3324", @"xanadu":@"#738678", @"brightGreen":@"#66ff00", @"nadeshikoPink":@"#f6adc6", @"beauBlue":@"#bcd4e6", @"electricBlue":@"#7df9ff", @"oldLavender":@"#796878", @"bazaar":@"#98777b", @"sunset":@"#fad6a5", @"shadow":@"#8a795d", @"darkPastelGreen":@"#03c03c", @"upsdellRed":@"#ae2029", @"bananaYellow":@"#ffe135", @"davyGrey":@"#555555", @"tumbleweed":@"#deaa88", @"bole":@"#79443b", @"safetyOrange":@"#ff6700", @"violet":@"#ee82ee", @"portlandOrange":@"#ff5a36", @"cambridgeBlue":@"#a3c1ad", @"pastelBlue":@"#aec6cf", @"burlywood":@"#deb887", @"paleTaupe":@"#bc987e", @"hotPink":@"#ff69b4", @"ruddyBrown":@"#bb6528", @"scarlet":@"#ff2400", @"brilliantRose":@"#ff55a3", @"ferrariRed":@"#ff2800", @"lightThulianPink":@"#e68fac", @"mountbattenPink":@"#997a8d", @"lightSalmonPink":@"#ff9999", @"caribbeanGreen":@"#00cc99", @"tropicalRainForest":@"#00755e", @"yellowOrange":@"#ffae42", @"chromeYellow":@"#ffa700", @"lightCornflowerBlue":@"#93ccea", @"peachYellow":@"#fadfad", @"darkCyan":@"#008b8b", @"orangeYellow":@"#f8d568", @"lightGreen":@"#90ee90", @"raspberryPink":@"#e25098", @"richBlack":@"#004040", @"sand":@"#c2b280", @"cosmicLatte":@"#fff8e7", @"crimsonGlory":@"#be0032", @"taupe":@"#483c32", @"malachite":@"#0bda51", @"languidLavender":@"#d6cadd", @"blond":@"#faf0be", @"famous":@"#ff00ff", @"oliveGreen":@"#bab86c", @"lightKhaki":@"#f0e68c", @"violetRed":@"#f75394", @"wisteria":@"#c9a0dc", @"pastelRed":@"#ff6961", @"pineGreen":@"#01796f", @"darkOrange":@"#ff8c00", @"byzantine":@"#bd33a4", @"maroon":@"#800000", @"guppieGreen":@"#00ff7f", @"isabelline":@"#f4f0ec", @"auburn":@"#a52a2a", @"citrine":@"#e4d00a", @"navajoWhite":@"#ffdead", @"byzantium":@"#702963", @"richElectricBlue":@"#0892d0", @"mediumPurple":@"#9370db", @"ufoGreen":@"#3cd070", @"nonPhotoBlue":@"#a4dded", @"bone":@"#e3dac9", @"coolBlack":@"#002e63", @"burntOrange":@"#cc5500", @"northTexasGreen":@"#059033", @"tangerine":@"#f28500", @"utahCrimson":@"#d3003f", @"tiffanyBlue":@"#0abab5", @"salmon":@"#ff8c69", @"emerald":@"#50c878", @"saffron":@"#f4c430", @"richLilac":@"#b666d2", @"pastelViolet":@"#cb99c9", @"ruddy":@"#ff0028", @"capri":@"#00bfff", @"yellow":@"#ffff00", @"laSalleGreen":@"#087830", @"sapGreen":@"#507d2a", @"pastelMagenta":@"#f49ac2", @"mediumCandyAppleRed":@"#e2062c", @"aqua":@"#00ffff", @"internationalKleinBlue":@"#002fa7", @"kuCrimson":@"#e8000d", @"prussianBlue":@"#003153", @"gold":@"#ffd700", @"paleGold":@"#e6be8a", @"eggplant":@"#614051", @"roseEbony":@"#674846", @"celeste":@"#b2ffff", @"salmonPink":@"#ff91a4", @"aliceBlue":@"#f0f8ff", @"ultraPink":@"#ff6fff", @"terraCotta":@"#e2725b", @"tangerineYellow":@"#ffcc00", @"tealGreen":@"#006d5b", @"vividAuburn":@"#922724", @"camel":@"#c19a6b", @"coffee":@"#6f4e37", @"princetonOrange":@"#ff8f00", @"pastelOrange":@"#ffb347", @"blueGray":@"#6699cc", @"screaminGreen":@"#76ff7a", @"mediumLavenderMagenta":@"#dda0dd", @"caputMortuum":@"#592720", @"seashell":@"#fff5ee", @"lava":@"#cf1020", @"rose":@"#ff007f", @"deepCarmine":@"#a9203e", @"springGreen":@"#00ff7f", @"mediumOrchid":@"#ba55d3", @"cream":@"#fffdd0", @"grannySmithApple":@"#a8e4a0", @"rosewood":@"#65000b", @"phthaloGreen":@"#123524", @"charcoal":@"#36454f", @"oldRose":@"#c08081", @"raspberry":@"#e30b5d", @"uscCardinal":@"#990000", @"mordantRed19":@"#ae0c00", @"drab":@"#967117", @"darkGreen":@"#013220", @"greenYellow":@"#adff2f", @"uaBlue":@"#0033aa", @"khaki":@"#c3b091", @"radicalRed":@"#ff355e", @"jasper":@"#d73b3e", @"saintPatrickBlue":@"#23297a", @"yaleBlue":@"#0f4d92", @"mediumCarmine":@"#af4035", @"cadetGrey":@"#91a3b0", @"fallow":@"#c19a6b", @"toolbox":@"#746cc0", @"indiaGreen":@"#138808", @"lightSeaGreen":@"#20b2aa", @"cadet":@"#536872", @"palePlum":@"#dda0dd", @"darkRaspberry":@"#872657", @"myrtle":@"#21421e", @"thulianPink":@"#de6fa1", @"harvardCrimson":@"#c90016", @"magnolia":@"#f8f4ff", @"roseMadder":@"#e32636", @"twilightLavender":@"#8a496b", @"armyGreen":@"#4b5320", @"selectiveYellow":@"#ffba00", @"lust":@"#e62020", @"mulberry":@"#c54b8c", @"teaRose":@"#f4c2c2", @"cinnabar":@"#e34234", @"bubbleGum":@"#ffc1cc", @"mauve":@"#e0b0ff", @"rawSienna":@"#d68a59", @"magenta":@"#ff00ff", @"sealBrown":@"#321414", @"debianRed":@"#d70a53", @"hansaYellow":@"#e9d66b", @"laserLemon":@"#fefe22", @"mediumChampagne":@"#f3e5ab", @"rifleGreen":@"#414833", @"eggshell":@"#f0ead6", @"naplesYellow":@"#fada5e", @"brilliantLavender":@"#f4bbff", @"viridian":@"#40826d", @"darkJungleGreen":@"#1a2421", @"brightUbe":@"#d19fe8", @"raspberryRose":@"#b3446c", @"tickleMePink":@"#fc89ac", @"shockingPink":@"#fc0fc0", @"green":@"#00ff00", @"celestialBlue":@"#4997d0", @"tan":@"#d2b48c", @"plum":@"#dda0dd", @"caféNoir":@"#4b3621", @"roseVale":@"#ab4e52", @"skyMagenta":@"#cf71af", @"deepFuchsia":@"#c154c1", @"darkPink":@"#e75480", @"palePink":@"#fadadd", @"brown":@"#a52a2a", @"pearlAqua":@"#88d8c0", @"hanBlue":@"#446ccf", @"babyBlueEyes":@"#a1caf1", @"lightSlateGray":@"#778899", @"sepia":@"#704214", @"egyptianBlue":@"#1034a6", @"navyBlue":@"#000080", @"darkScarlet":@"#560319", @"cordovan":@"#893f45", @"columbiaBlue":@"#9bddff", @"officeGreen":@"#008000", @"bistre":@"#3d2b1f", @"arylideYellow":@"#e9d66b", @"fandango":@"#b53389", @"cadetBlue":@"#5f9ea0", @"sapphire":@"#0f52ba", @"paleSpringBud":@"#ecebbd", @"bisque":@"#ffe4c4", @"deepSaffron":@"#ff9933", @"jazzberryJam":@"#a50b5e", @"chestnut":@"#cd5c5c", @"darkOliveGreen":@"#556b2f", @"waterspout":@"#00ffff", @"wildStrawberry":@"#ff43a4", @"deepChestnut":@"#b94e48", @"brinkPink":@"#fb607f", @"ruby":@"#e0115f", @"darkSeaGreen":@"#8fbc8f", @"lavenderPurple":@"#967bb6", @"oldGold":@"#cfb53b", @"lightCrimson":@"#f56991", @"paleChestnut":@"#ddadaf", @"oliveDrab":@"#6b8e23", @"ruddyPink":@"#e18e96", @"midnightBlue":@"#191970", @"springBud":@"#a7fc00", @"neonGreen":@"#39ff14", @"electricPurple":@"#bf00ff", @"msuGreen":@"#18453b", @"brightCerulean":@"#1dacd6", @"wheat":@"#f5deb3", @"brightTurquoise":@"#08e8de", @"mintGreen":@"#98ff98", @"titaniumYellow":@"#eee600", @"parisGreen":@"#50c878", @"deepPink":@"#ff1493", @"paleGreen":@"#98fb98", @"lemonYellow":@"#fff44f", @"thistle":@"#d8bfd8", @"universityOfCaliforniaGold":@"#b78727", @"oxfordBlue":@"#002147", @"denim":@"#1560bd", @"canaryYellow":@"#ffef00", @"cgRed":@"#e03c31", @"americanRose":@"#ff033e", @"carnelian":@"#b31b1b", @"gamboge":@"#e49b0f", @"rust":@"#b7410e", @"purpleHeart":@"#69359c", @"corn":@"#fbec5d", @"grayAsparagus":@"#465945", @"lavender":@"#e6e6fa", @"frenchRose":@"#f64a8a" };
    });
    return colors;
}

@end
