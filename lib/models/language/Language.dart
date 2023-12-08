// To parse this JSON data, do
//
//     final language = languageFromJson(jsonString);

import 'dart:convert';

Language languageFromJson(String str) => Language.fromJson(json.decode(str));

String languageToJson(Language data) => json.encode(data.toJson());

class Language {
	Language({
	required	this.home,
	required	this.tertip,
	required	this.details,
	required	this.register,
	required	this.login,
	required	this.brend,
	required	this.aboutUs,
	required	this.cart,
	required	this.payment,
	required	this.accont,
	required	this.orders,
	required	this.bizBaarad,
	required	this.eltipBer,
	required	this.habarlas,
	required	this.ulanysDuz,
	required	this.gosmaca,
	required	this.perewod,
	});

	Home home;
	String tertip;
	Details details;
	Register register;
	Login login;
	String brend;
	String aboutUs;
	Cart cart;
	Payment payment;
	Accont accont;
	Orders orders;
	String bizBaarad;
	String eltipBer;
	String habarlas;
	String ulanysDuz;
	Gosmaca gosmaca;
	Perewod perewod;

	factory Language.fromJson(Map<String, dynamic> json) => Language(
		home: Home.fromJson(json["home"]),
		tertip: json["Tertip"],
		details: Details.fromJson(json["Details"]),
		register: Register.fromJson(json["Register"]),
		login: Login.fromJson(json["Login"]),
		brend: json["Brend"],
		aboutUs: json["AboutUs"],
		cart: Cart.fromJson(json["Cart"]),
		payment: Payment.fromJson(json["Payment"]),
		accont: Accont.fromJson(json["Accont"]),
		orders: Orders.fromJson(json["Orders"]),
		bizBaarad: json["BizBaarad"],
		eltipBer: json["EltipBer"],
		habarlas: json["Habarlas"],
		ulanysDuz: json["UlanysDuz"],
		gosmaca: Gosmaca.fromJson(json["Gosmaca"]),
		perewod: Perewod.fromJson(json["perewod"]),
	);

	Map<String, dynamic> toJson() => {
		"home": home.toJson(),
		"Tertip": tertip,
		"Details": details.toJson(),
		"Register": register.toJson(),
		"Login": login.toJson(),
		"Brend": brend,
		"AboutUs": aboutUs,
		"Cart": cart.toJson(),
		"Payment": payment.toJson(),
		"Accont": accont.toJson(),
		"Orders": orders.toJson(),
		"BizBaarad": bizBaarad,
		"EltipBer": eltipBer,
		"Habarlas": habarlas,
		"UlanysDuz": ulanysDuz,
		"Gosmaca": gosmaca.toJson(),
		"perewod": perewod.toJson(),
	};
}

class Accont {
	Accont({
	required	this.hasabym,
	required	this.ady,
	required	this.telefon,
	required	this.salgym,
	required	this.agza,
	required	this.acar,
	});

	String hasabym;
	String ady;
	String telefon;
	String salgym;
	String agza;
	String acar;

	factory Accont.fromJson(Map<String, dynamic> json) => Accont(
		hasabym: json["Hasabym"],
		ady: json["Ady"],
		telefon: json["Telefon"],
		salgym: json["Salgym"],
		agza: json["Agza"],
		acar: json["Acar"],
	);

	Map<String, dynamic> toJson() => {
		"Hasabym": hasabym,
		"Ady": ady,
		"Telefon": telefon,
		"Salgym": salgym,
		"Agza": agza,
		"Acar": acar,
	};
}

class Cart {
	Cart({
	required	this.sebedim,
	required	this.jemi,
	required	this.sargyt,
	});

	String sebedim;
	String jemi;
	String sargyt;

	factory Cart.fromJson(Map<String, dynamic> json) => Cart(
		sebedim: json["Sebedim"],
		jemi: json["Jemi"],
		sargyt: json["Sargyt"],
	);

	Map<String, dynamic> toJson() => {
		"Sebedim": sebedim,
		"Jemi": jemi,
		"Sargyt": sargyt,
	};
}

class Details {
	Details({
	required	this.gos,
	required	this.menzes,
	});

	String gos;
	String menzes;

	factory Details.fromJson(Map<String, dynamic> json) => Details(
		gos: json["Gos"],
		menzes: json["Menzes"],
	);

	Map<String, dynamic> toJson() => {
		"Gos": gos,
		"Menzes": menzes,
	};
}

class Gosmaca {
	Gosmaca({
	required	this.doldur,
	required	this.telefon,
	required	this.garasmak,
	required	this.agzaBolan,
required		this.kod,
	required	this.dilCalys,
	required	this.habarlas,
	required	this.hat,
	required	this.ugrat,
	required	this.acar,
	required	this.ulgam,
	required	this.cykmak,
	required	this.duydurys,
	required	this.cykdynyz,
	required	this.giriz,
	required	this.basSahypa,
	required	this.hasabym,
	required	this.hemmeSayla,
	required	this.goybulsun,
	required	this.sayla,
	required	this.kabul,
	required	this.bermek,
	required	this.taze,
	required	this.tazelendi,
	required	this.onkiAcar,
	required	this.haryt,
	required	this.az,
	required	this.kody,
	required	this.incorrect,
	required	this.alynmadyk,
	required	this.tazeden,
	required	this.gaytadan,
	required	this.arzan,
	required	this.gymmat,
	required	this.tertip,
	});

	String doldur;
	String telefon;
	String garasmak;
	String agzaBolan;
	String kod;
	String dilCalys;
	String habarlas;
	String hat;
	String ugrat;
	String acar;
	String ulgam;
	String cykmak;
	String duydurys;
	String cykdynyz;
	String giriz;
	String basSahypa;
	String hasabym;
	String hemmeSayla;
	String goybulsun;
	String sayla;
	String kabul;
	String bermek;
	String taze;
	String tazelendi;
	String onkiAcar;
	String haryt;
	String az;
	String kody;
	String incorrect;
	String alynmadyk;
	String tazeden;
	String gaytadan;
	String arzan;
	String gymmat;
	String tertip;

	factory Gosmaca.fromJson(Map<String, dynamic> json) => Gosmaca(
		doldur: json["Doldur"],
		telefon: json["Telefon"],
		garasmak: json["Garasmak"],
		agzaBolan: json["agzaBolan"],
		kod: json["kod"],
		dilCalys: json["DilCalys"],
		habarlas: json["Habarlas"],
		hat: json["Hat"],
		ugrat: json["ugrat"],
		acar: json["acar"],
		ulgam: json["Ulgam"],
		cykmak: json["Cykmak"],
		duydurys: json["Duydurys"],
		cykdynyz: json["Cykdynyz"],
		giriz: json["Giriz"],
		basSahypa: json["basSahypa"],
		hasabym: json["Hasabym"],
		hemmeSayla: json["hemmeSayla"],
		goybulsun: json["Goybulsun"],
		sayla: json["Sayla"],
		kabul: json["kabul"],
		bermek: json["bermek"],
		taze: json["taze"],
		tazelendi: json["Tazelendi"],
		onkiAcar: json["onkiAcar"],
		haryt: json["haryt"],
		az: json["Az"],
		kody: json["kody"],
		incorrect: json["Incorrect"],
		alynmadyk: json["Alynmadyk"],
		tazeden: json["Tazeden"],
		gaytadan: json["gaytadan"],
		arzan: json["arzan"],
		gymmat: json["gymmat"],
		tertip: json["tertip"],
	);

	Map<String, dynamic> toJson() => {
		"Doldur": doldur,
		"Telefon": telefon,
		"Garasmak": garasmak,
		"agzaBolan": agzaBolan,
		"kod": kod,
		"DilCalys": dilCalys,
		"Habarlas": habarlas,
		"Hat": hat,
		"ugrat": ugrat,
		"acar": acar,
		"Ulgam": ulgam,
		"Cykmak": cykmak,
		"Duydurys": duydurys,
		"Cykdynyz": cykdynyz,
		"Giriz": giriz,
		"basSahypa": basSahypa,
		"Hasabym": hasabym,
		"hemmeSayla": hemmeSayla,
		"Goybulsun": goybulsun,
		"Sayla": sayla,
		"kabul": kabul,
		"bermek": bermek,
		"taze": taze,
		"Tazelendi": tazelendi,
		"onkiAcar": onkiAcar,
		"haryt": haryt,
		"Az": az,
		"kody": kody,
		"Incorrect": incorrect,
		"Alynmadyk": alynmadyk,
		"Tazeden": tazeden,
		"gaytadan": gaytadan,
		"arzan": arzan,
		"gymmat": gymmat,
		"tertip": tertip,
	};
}

class Home {
	Home({
	required	this.iceri,
	required	this.agza,
	required	this.kategor,
	required	this.brend,
	required	this.haryt,
	required	this.sebet,
	required	this.arzan,
	required	this.ahlisi,
	required	this.manat,
	required	this.bizbarada,
	required	this.eltip,
	required	this.aragat,
	required	this.ulanys,
	required	this.hukuk,
	required	this.geekSpace,
	});

	String iceri;
	String agza;
	String kategor;
	String brend;
	String haryt;
	String sebet;
	String arzan;
	String ahlisi;
	String manat;
	String bizbarada;
	String eltip;
	String aragat;
	String ulanys;
	String hukuk;
	String geekSpace;

	factory Home.fromJson(Map<String, dynamic> json) => Home(
		iceri: json["iceri"],
		agza: json["Agza"],
		kategor: json["Kategor"],
		brend: json["Brend"],
		haryt: json["Haryt"],
		sebet: json["Sebet"],
		arzan: json["Arzan"],
		ahlisi: json["Ahlisi"],
		manat: json["Manat"],
		bizbarada: json["Bizbarada"],
		eltip: json["Eltip"],
		aragat: json["Aragat"],
		ulanys: json["Ulanys"],
		hukuk: json["Hukuk"],
		geekSpace: json["GeekSpace"],
	);

	Map<String, dynamic> toJson() => {
		"iceri": iceri,
		"Agza": agza,
		"Kategor": kategor,
		"Brend": brend,
		"Haryt": haryt,
		"Sebet": sebet,
		"Arzan": arzan,
		"Ahlisi": ahlisi,
		"Manat": manat,
		"Bizbarada": bizbarada,
		"Eltip": eltip,
		"Aragat": aragat,
		"Ulanys": ulanys,
		"Hukuk": hukuk,
		"GeekSpace": geekSpace,
	};
}

class Login {
	Login({
	required	this.iceriGir,
	required	this.telefon,
	required	this.acar,
	required	this.forgetKey,
	required	this.logIn,
	required	this.signUp,
	});

	String iceriGir;
	String telefon;
	String acar;
	String forgetKey;
	String logIn;
	String signUp;

	factory Login.fromJson(Map<String, dynamic> json) => Login(
		iceriGir: json["IceriGir"],
		telefon: json["Telefon"],
		acar: json["Acar"],
		forgetKey: json["ForgetKey"],
		logIn: json["LogIn"],
		signUp: json["SignUp"],
	);

	Map<String, dynamic> toJson() => {
		"IceriGir": iceriGir,
		"Telefon": telefon,
		"Acar": acar,
		"ForgetKey": forgetKey,
		"LogIn": logIn,
		"SignUp": signUp,
	};
}

class Orders {
	Orders({
	required	this.sargyt,
	required	this.sargytTaryh,
	required	this.haryt,
	required	this.jemi,
	required	this.sargytYag,
	required	this.sargytMaglumat,
	required	this.gowsur,
	required	this.tayyarlan,
	required	this.goybulsun,
	});

	String sargyt;
	String sargytTaryh;
	String haryt;
	String jemi;
	String sargytYag;
	String sargytMaglumat;
	String gowsur;
	String tayyarlan;
	String goybulsun;

	factory Orders.fromJson(Map<String, dynamic> json) => Orders(
		sargyt: json["Sargyt"],
		sargytTaryh: json["SargytTaryh"],
		haryt: json["Haryt"],
		jemi: json["Jemi"],
		sargytYag: json["SargytYag"],
		sargytMaglumat: json["SargytMaglumat"],
		gowsur: json["Gowsur"],
		tayyarlan: json["Tayyarlan"],
		goybulsun: json["Goybulsun"],
	);

	Map<String, dynamic> toJson() => {
		"Sargyt": sargyt,
		"SargytTaryh": sargytTaryh,
		"Haryt": haryt,
		"Jemi": jemi,
		"SargytYag": sargytYag,
		"SargytMaglumat": sargytMaglumat,
		"Gowsur": gowsur,
		"Tayyarlan": tayyarlan,
		"Goybulsun": goybulsun,
	};
}

class Payment {
	Payment({
	required	this.sebet,
	required	this.tolegSek,
	required	this.nagt,
	required	this.toleg,
	required	this.onlaynToleg,
	required	this.aljak,
	required	this.wagty,
	required	this.suGun,
	required	this.ertir,
	required	this.sargyt,
	required	this.adynyz,
	required	this.telefon,
	required	this.salgynyz,
	required	this.bellik,
	required	this.tasslyk,
	required	this.tabsyr,
	});

	String sebet;
	String tolegSek;
	String nagt;
	String toleg;
	String onlaynToleg;
	String aljak;
	String wagty;
	String suGun;
	String ertir;
	String sargyt;
	String adynyz;
	String telefon;
	String salgynyz;
	String bellik;
	String tasslyk;
	String tabsyr;

	factory Payment.fromJson(Map<String, dynamic> json) => Payment(
		sebet: json["Sebet"],
		tolegSek: json["TolegSek"],
		nagt: json["Nagt"],
		toleg: json["Toleg"],
		onlaynToleg: json["OnlaynToleg"],
		aljak: json["Aljak"],
		wagty: json["Wagty"],
		suGun: json["SuGun"],
		ertir: json["Ertir"],
		sargyt: json["Sargyt"],
		adynyz: json["Adynyz"],
		telefon: json["Telefon"],
		salgynyz: json["Salgynyz"],
		bellik: json["Bellik"],
		tasslyk: json["Tasslyk"],
		tabsyr: json["Tabsyr"],
	);

	Map<String, dynamic> toJson() => {
		"Sebet": sebet,
		"TolegSek": tolegSek,
		"Nagt": nagt,
		"Toleg": toleg,
		"OnlaynToleg": onlaynToleg,
		"Aljak": aljak,
		"Wagty": wagty,
		"SuGun": suGun,
		"Ertir": ertir,
		"Sargyt": sargyt,
		"Adynyz": adynyz,
		"Telefon": telefon,
		"Salgynyz": salgynyz,
		"Bellik": bellik,
		"Tasslyk": tasslyk,
		"Tabsyr": tabsyr,
	};
}

class Perewod {
	Perewod({
	required	this.add,
	required	this.change,
	required	this.delete,
	required	this.addcard,
	required	this.deletecard,
	required	this.yes,
	required	this.no,
	required	this.search,
	required	this.time,
	required	this.remember,
	required	this.have,
	required	this.oldpas,
required		this.deleteAcou,
		required		this.end,
		required		this.sany,
		required		this.kabul,
		required this.duydur,
		required this.doly
	});

	String add;
	String change;
	String delete;
	String addcard;
	String deletecard;
	String yes;
	String no;
	String search;
	String time;
	String remember;
	String have;
	String oldpas;
	String deleteAcou;
	String end;
	String sany;
	String kabul;
String duydur;
String doly;
	factory Perewod.fromJson(Map<String, dynamic> json) => Perewod(
		add: json["add"],
		change: json["change"],
		delete: json["delete"],
		addcard: json["addcard"],
		deletecard: json["deletecard"],
		yes: json["yes"],
		no: json["no"],
		search: json["search"],
		time: json["time"],
		remember: json["remember"],
		have: json["have"],
		oldpas: json["oldpas"],
		deleteAcou: json["deleteAcou"],
		end: json["end"],
		sany: json["sany"],
		kabul: json["kabul"],
		duydur: json["duydur"],
		doly: json["doly"]
	);

	Map<String, dynamic> toJson() => {
		"add": add,
		"change": change,
		"delete": delete,
		"addcard": addcard,
		"deletecard": deletecard,
		"yes": yes,
		"no": no,
		"search": search,
		"time": time,
		"remember": remember,
		"have": have,
		"oldpas": oldpas,
		"deleteAcou": deleteAcou,
		"end": end,
		"sany": sany,
		"kabul": kabul,
		"duydur":duydur
	};
}

class Register {
	Register({
required		this.yazyl,
required		this.agza,
required		this.ady,
required		this.tel,
required		this.acar,
	required	this.acarTasyk,
	required	this.ulanys,
	required	this.agzaBol,
	required	this.iceri,
	});

	String yazyl;
	String agza;
	String ady;
	String tel;
	String acar;
	String acarTasyk;
	String ulanys;
	String agzaBol;
	String iceri;

	factory Register.fromJson(Map<String, dynamic> json) => Register(
		yazyl: json["Yazyl"],
		agza: json["Agza"],
		ady: json["Ady"],
		tel: json["Tel"],
		acar: json["Acar"],
		acarTasyk: json["AcarTasyk"],
		ulanys: json["Ulanys"],
		agzaBol: json["AgzaBol"],
		iceri: json["Iceri"],
	);

	Map<String, dynamic> toJson() => {
		"Yazyl": yazyl,
		"Agza": agza,
		"Ady": ady,
		"Tel": tel,
		"Acar": acar,
		"AcarTasyk": acarTasyk,
		"Ulanys": ulanys,
		"AgzaBol": agzaBol,
		"Iceri": iceri,
	};
}
