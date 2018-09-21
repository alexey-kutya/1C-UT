﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	
	ПараметрыФормы = Новый Структура("ЗначениеОтбора", ПолучитьСписокОбращений(ПараметрКоманды));
	ОткрытьФорму("Документ.Обращение.Форма.ОбращенияПоВнешнейОбработке", 
		ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
	
&НаСервере
//&НаСервереБезКонтекста
Функция ПолучитьСписокОбращений(ВнешняяОбработка)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбращениеВнешниеОтчетыИОбработки.Ссылка
		|ИЗ
		|	Документ.Обращение.ВнешниеОтчетыИОбработки КАК ОбращениеВнешниеОтчетыИОбработки
		|ГДЕ
		|	ОбращениеВнешниеОтчетыИОбработки.ВнешняяОбработка = &ВнешняяОбработка
		|
		|СГРУППИРОВАТЬ ПО
		|	ОбращениеВнешниеОтчетыИОбработки.Ссылка";
	
	Запрос.УстановитьПараметр("ВнешняяОбработка", ВнешняяОбработка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат СписокЗначений;

КонецФункции // ПолучитьСписокОбращений()
 
	
	
