﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("Документ.ИзменениеКонфигурации.Форма.ИзмененияПоОбращению",
		Новый Структура("ЗначениеОтбора", ПараметрКоманды),
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Источник.КлючУникальности,
			ПараметрыВыполненияКоманды.Окно);	
КонецПроцедуры
