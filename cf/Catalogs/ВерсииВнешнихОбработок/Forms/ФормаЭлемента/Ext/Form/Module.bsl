﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
		Элементы.ПолноеНаименование.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.Автор.ТолькоПросмотр = Ложь;
		Элементы.ДатаСоздания.ТолькоПросмотр = Ложь;
		Элементы.РодительскаяВерсия.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	ВидДополнительныйОтчет     = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет;
	
	//ОбщиеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ОбщиеНастройкиРаботыСФайлами();
	//
	//РасширениеФайлаВСписке = ФайловыеФункцииСлужебныйКлиентСервер.РасширениеФайлаВСписке(
	//	ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, Объект.Расширение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Файл", Новый Структура("Событие", "ВерсияСохранена"), Объект.Владелец);
//	ОбновитьТекущуюВерсиюНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекущуюВерсиюНаСервере()
	Объект.Владелец.ПолучитьОбъект().ОбновитьТекущуюВерсию(Объект.Ссылка);
КонецПроцедуры // ОбновитьТекущуюВерсиюНаСервере()
 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	Объект.Наименование = Объект.ПолноеНаименование;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьКак1(Команда)
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Неопределено,
		Объект.Ссылка,
		УникальныйИдентификатор);
	
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(
		Неопределено,
		ДанныеФайла,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ЭтоОтчет", ТИ.ПолучитьРеквизитПоСсылке(Объект.Владелец, "ВидОбработки") = ВидДополнительныйОтчет);
	ПараметрыВыгрузки.Вставить("ИмяФайла", ТИ.ПолучитьРеквизитПоСсылке(Объект.Владелец, "ИмяФайла"));
	ПараметрыВыгрузки.Вставить("АдресДанных", АдресДанных);
	ДополнительныеОтчетыИОбработкиКлиент.ВыгрузитьВФайл(ПараметрыВыгрузки);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХранимыеОбработкиВерсий.ХранимыйФайл
		|ИЗ
		|	РегистрСведений.ХранимыеОбработкиВерсий КАК ХранимыеОбработкиВерсий
		|ГДЕ
		|	ХранимыеОбработкиВерсий.ВерсияФайла = &ВерсияФайла";
	
	Запрос.УстановитьПараметр("ВерсияФайла", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		АдресДанных = ПоместитьВоВременноеХранилище(
				ВыборкаДетальныеЗаписи.ХранимыйФайл.Получить(),
				УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДоступностью()
	
	Если ТИ.ДоступнаРоль("ПолныеПрава") Тогда
		Возврат;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Объект.ТекущийРазработчик) Тогда
		Разработчик = Объект.ТекущийРазработчик;
	Иначе
		Разработчик = Объект.Автор;
	КонецЕсли;
	
	Если Разработчик = ТИ.ТекущийПользователь() Тогда
		ЭтаФорма.ТолькоПросмотр = Ложь;
	Иначе	
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры // УправлениеДоступностью()

#КонецОбласти
