﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Файл", ПараметрКоманды);
	ПараметрыФормы.Вставить("УникальныйИдентификаторКарточкиФайла",
		ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
	
	ОткрытьФорму(
		"Справочник.ВерсииВнешнихОбработок.Форма.ВерсииФайла",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
