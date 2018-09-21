﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Заполнение вспомогательных данных.
	
	ЗапретРедактированияРолей = ПользователиСлужебный.ЗапретРедактированияРолей();
	
	// Заполнение списка выбора языка.
	Если Метаданные.Языки.Количество() < 2 Тогда
		Элементы.ПользовательИнфБазыЯзык.Видимость = Ложь;
	Иначе
		Для каждого МетаданныеЯзыка ИЗ Метаданные.Языки Цикл
			Элементы.ПользовательИнфБазыЯзык.СписокВыбора.Добавить(
				МетаданныеЯзыка.Имя, МетаданныеЯзыка.Синоним);
		КонецЦикла;
	КонецЕсли;
	
	// Подготовка к интерактивным действиям с учетом сценариев открытия формы.
	УровеньДоступа = ПользователиСлужебный.УровеньДоступаКСвойствамПользователя(Объект);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		// Создание нового элемента.
		Если Параметры.ГруппаНовогоВнешнегоПользователя
		         <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			
			ГруппаНовогоВнешнегоПользователя = Параметры.ГруппаНовогоВнешнегоПользователя;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			// Копирование элемента.
			ЗначениеКопирования = Параметры.ЗначениеКопирования;
			Объект.ОбъектАвторизации = Неопределено;
			Объект.Наименование      = "";
			Объект.УдалитьПароль     = "";
			
			Если Пользователи.ЭтоПолноправныйПользователь(ЗначениеКопирования, Истина, Ложь) Тогда
				РазрешеноКопированиеПользователяИБ = УровеньДоступа.АдминистраторСистемы;
			ИначеЕсли Пользователи.ЭтоПолноправныйПользователь(ЗначениеКопирования, Ложь, Ложь) Тогда
				РазрешеноКопированиеПользователяИБ = УровеньДоступа.ПолныеПрава;
			Иначе
				РазрешеноКопированиеПользователяИБ = Истина;
			КонецЕсли;
			
			Если РазрешеноКопированиеПользователяИБ Тогда
				ПрочитатьПользователяИБ(ЗначениеЗаполнено(
					Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ));
			Иначе
				ПрочитатьПользователяИБ();
			КонецЕсли;
			Если Не УровеньДоступа.ПолныеПрава Тогда
				ВходВПрограммуРазрешен = Ложь;
				ВходВПрограммуРазрешенЗначениеПрямогоИзменения = Ложь;
			КонецЕсли;
		Иначе
			// Добавление элемента.
			Если Параметры.Свойство("ОбъектАвторизацииНовогоВнешнегоПользователя") Тогда
				
				Объект.ОбъектАвторизации = Параметры.ОбъектАвторизацииНовогоВнешнегоПользователя;
				ОбъектАвторизацииЗаданПриОткрытии = ЗначениеЗаполнено(Объект.ОбъектАвторизации);
				ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(ЭтотОбъект, Объект);
				
			ИначеЕсли ЗначениеЗаполнено(ГруппаНовогоВнешнегоПользователя) Тогда
				
				ТипОбъектовАвторизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
					ГруппаНовогоВнешнегоПользователя, "ТипОбъектовАвторизации");
				
				Объект.ОбъектАвторизации = ТипОбъектовАвторизации;
				Элементы.ОбъектАвторизации.ВыбиратьТип = ТипОбъектовАвторизации = Неопределено;
			КонецЕсли;
			
			// Чтение начальных значений свойств пользователя ИБ.
			ПрочитатьПользователяИБ();
			
			Если Не ЗначениеЗаполнено(Параметры.ИдентификаторПользователяИБ) Тогда
				ПользовательИнфБазыАутентификацияСтандартная = Истина;
				
				Если УровеньДоступа.ПолныеПрава Тогда
					ВходВПрограммуРазрешен = Истина;
					ВходВПрограммуРазрешенЗначениеПрямогоИзменения = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если УровеньДоступа.ПолныеПрава
		   И Объект.ОбъектАвторизации <> Неопределено Тогда
			
			ПользовательИнфБазыИмя = ПользователиСлужебныйКлиентСервер.ПолучитьКраткоеИмяПользователяИБ(
				ТекущееПредставлениеОбъектаАвторизации);
			
			ПользовательИнфБазыПолноеИмя = Объект.Наименование;
		КонецЕсли;
	Иначе
		// Открытие существующего элемента.
		ПрочитатьПользователяИБ();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриСозданииФормы", Истина);
	НачальноеОписаниеПользователяИБ = НачальноеОписаниеПользователяИБ();
	
	ОбщаяНастройкаФормы(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбщаяНастройкаФормы();
	
	ТекущееПредставлениеОбъектаАвторизации = Строка(Объект.ОбъектАвторизации);
	
КонецПроцедуры

&НаСервере
Процедура ОбщаяНастройкаФормы(ПриСозданииНаСервере = Ложь, ПараметрыЗаписи = Неопределено)
	
	Если НачальноеОписаниеПользователяИБ = Неопределено Тогда
		Возврат; // Вызов ПриЧтенииНаСервере до вызова ПриСозданииНаСервере.
	КонецЕсли;
	
	Если Не ПриСозданииНаСервере Тогда
		ПрочитатьПользователяИБ();
	КонецЕсли;
	
	УровеньДоступа = ПользователиСлужебный.УровеньДоступаКСвойствамПользователя(Объект);
	
	ОпределитьДействияВФорме();
	
	ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи);
	
	// Установка постоянной доступности свойств.
	Элементы.СвойстваПользователяИБ.Видимость =
		ЗначениеЗаполнено(ДействияВФорме.СвойстваПользователяИБ);
	
	Элементы.ОтображениеРолей.Видимость =
		ЗначениеЗаполнено(ДействияВФорме.Роли);
	
	Элементы.УстановитьРолиНепосредственно.Видимость =
		ЗначениеЗаполнено(ДействияВФорме.Роли) И НЕ ПользователиСлужебный.ЗапретРедактированияРолей();
	
	ОбновитьОтображаемыйТипПользователя();
	
	ТолькоПросмотр = ТолькоПросмотр
		ИЛИ ДействияВФорме.Роли                   <> "Редактирование"
		  И ДействияВФорме.СвойстваЭлемента       <> "Редактирование"
		  И ДействияВФорме.СвойстваПользователяИБ <> "Редактирование";
	
	Элементы.РекомендуетсяПроверитьНастройкиДляВхода.Видимость =
		УровеньДоступа.ПолныеПрава И Объект.Подготовлен И Не ПриЧтенииВходВПрограммуРазрешен;
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОчиститьСообщения();
	
	Если ДействияВФорме.Роли = "Редактирование"
	   И Объект.УстановитьРолиНепосредственно
	   И ПользовательИнфБазыРоли.Количество() = 0 Тогда
		
		Если НЕ ПараметрыЗаписи.Свойство("СПустымСпискомРолей") Тогда
			Отказ = Истина;
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ПослеОтветаНаВопросОЗаписиСПустымСпискомРолей", ЭтотОбъект, ПараметрыЗаписи),
				НСтр("ru = 'Пользователю информационной базы не установлено ни одной роли. Продолжить?'"),
				РежимДиалогаВопрос.ДаНет,
				,
				,
				НСтр("ru = 'Запись пользователя информационной базы'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	
	ОбновитьОтображаемыйТипПользователя();
	// Автообновление наименования внешнего пользователя.
	УстановитьПривилегированныйРежим(Истина);
	ТекущееПредставлениеОбъектаАвторизации = Строка(ТекущийОбъект.ОбъектАвторизации);
	УстановитьПривилегированныйРежим(Ложь);
	Объект.Наименование        = ТекущееПредставлениеОбъектаАвторизации;
	ТекущийОбъект.Наименование = ТекущееПредставлениеОбъектаАвторизации;
	
	Если ТребуетсяЗаписьПользователяИБ(ЭтотОбъект) Тогда
		ОписаниеПользователяИБ = ОписаниеПользователяИБ();
		ОписаниеПользователяИБ.Удалить("ПодтверждениеПароля");
		
		Если ЗначениеЗаполнено(Объект.ИдентификаторПользователяИБ) Тогда
			ОписаниеПользователяИБ.Вставить("УникальныйИдентификатор", Объект.ИдентификаторПользователяИБ);
		КонецЕсли;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	КонецЕсли;
	
	Если ДействияВФорме.СвойстваЭлемента <> "Редактирование" Тогда
		ЗаполнитьЗначенияСвойств(ТекущийОбъект, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ТекущийОбъект.Ссылка, "ПометкаУдаления"));
	КонецЕсли;
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить(
		"ГруппаНовогоВнешнегоПользователя", ГруппаНовогоВнешнегоПользователя);
	
	УстановитьПривилегированныйРежим(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТребуетсяЗаписьПользователяИБ(ЭтотОбъект) Тогда
		ПараметрыЗаписи.Вставить(
			ТекущийОбъект.ДополнительныеСвойства.ОписаниеПользователяИБ.РезультатДействия);
	КонецЕсли;
	
	ОбщаяНастройкаФормы(, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВнешниеПользователи", Новый Структура, Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ДобавленПользовательИБ") Тогда
		Оповестить("ДобавленПользовательИБ", ПараметрыЗаписи.ДобавленПользовательИБ, ЭтотОбъект);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ИзмененПользовательИБ") Тогда
		Оповестить("ИзмененПользовательИБ", ПараметрыЗаписи.ИзмененПользовательИБ, ЭтотОбъект);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("УдаленПользовательИБ") Тогда
		Оповестить("УдаленПользовательИБ", ПараметрыЗаписи.УдаленПользовательИБ, ЭтотОбъект);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ОчищеноСопоставлениеСНесуществующимПользователемИБ") Тогда
		
		Оповестить(
			"ОчищеноСопоставлениеСНесуществующимПользователемИБ",
			ПараметрыЗаписи.ОчищеноСопоставлениеСНесуществующимПользователемИБ, ЭтотОбъект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГруппаНовогоВнешнегоПользователя) Тогда
		ОповеститьОбИзменении(ГруппаНовогоВнешнегоПользователя);
		
		Оповестить(
			"Запись_ГруппыВнешнихПользователей",
			Новый Структура,
			ГруппаНовогоВнешнегоПользователя);
		
		ГруппаНовогоВнешнегоПользователя = Неопределено;
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекстОшибки = "";
	Если ПользователиСлужебный.ОбъектАвторизацииИспользуется(
	         Объект.ОбъектАвторизации, Объект.Ссылка, , , ТекстОшибки) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки, , "Объект.ОбъектАвторизации", , Отказ);
	КонецЕсли;
	
	Если ТребуетсяЗаписьПользователяИБ(ЭтотОбъект) Тогда
		ОписаниеПользователяИБ = ОписаниеПользователяИБ();
		ОписаниеПользователяИБ.Вставить("ИдентификаторПользователяИБ", Объект.ИдентификаторПользователяИБ);
		ПользователиСлужебный.ПроверитьОписаниеПользователяИБ(ОписаниеПользователяИБ, Отказ);
		
		ТекстСообщения = "";
		Если ПользователиСлужебный.ТребуетсяСоздатьПервогоАдминистратора(, ТекстСообщения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, , "ВходВПрограммуРазрешен", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЗагрузкеНастроек", Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектАвторизацииПриИзменении(Элемент)
	
	ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура НедействителенПриИзменении(Элемент)
	
	Если Объект.Недействителен Тогда
		ВходВПрограммуРазрешен = Ложь;
	Иначе
		ВходВПрограммуРазрешен = ВходВПрограммуРазрешенЗначениеПрямогоИзменения
			И (ПользовательИнфБазыАутентификацияOpenID
			   Или ПользовательИнфБазыАутентификацияСтандартная);
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ВходВПрограммуРазрешенПриИзменении(Элемент)
	
	Если Объект.ПометкаУдаления И ВходВПрограммуРазрешен Тогда
		ВходВПрограммуРазрешен = Ложь;
		ПоказатьПредупреждение(,
			НСтр("ru = 'Чтобы разрешить вход в программу, требуется снять
			           |пометку на удаление с этого внешнего пользователя.'"));
		Возврат;
	КонецЕсли;
	
	ОбновитьИмяДляВхода(ЭтотОбъект);
	
	Если ВходВПрограммуРазрешен
	   И НЕ ПользовательИнфБазыАутентификацияOpenID
	   И НЕ ПользовательИнфБазыАутентификацияСтандартная Тогда
	
		ПользовательИнфБазыАутентификацияСтандартная = Истина;
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
	Если Не УровеньДоступа.ПолныеПрава
	   И УровеньДоступа.УправлениеСписком
	   И Не ВходВПрограммуРазрешен Тогда
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'После записи вход в программу сможет разрешить только администратор.'"));
	КонецЕсли;
	
	ВходВПрограммуРазрешенЗначениеПрямогоИзменения = ВходВПрограммуРазрешен;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыИмяПриИзменении(Элемент)
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыАутентификацияСтандартнаяПриИзменении(Элемент)
	
	АутентификацияПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	УстановитьДоступностьСвойств();
	
	ПользовательИнфБазыПароль = Пароль;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыЗапрещеноИзменятьПарольПриИзменении(Элемент)
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыАутентификацияOpenIDПриИзменении(Элемент)
	
	АутентификацияПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРолиНепосредственноПриИзменении(Элемент)
	
	Если НЕ Объект.УстановитьРолиНепосредственно Тогда
		ПрочитатьРолиПользователяИБ();
		ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРоли

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура РолиПометкаПриИзменении(Элемент)
	
	Если Элементы.Роли.ТекущиеДанные <> Неопределено Тогда
		ОбработатьИнтерфейсРолей("ОбновитьСоставРолей");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура ПоказатьТолькоВыбранныеРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ТолькоВыбранныеРоли");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаРолейПоПодсистемам(Команда)
	
	ОбработатьИнтерфейсРолей("ГруппировкаПоПодсистемам");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ВключитьВсе");
	
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ИсключитьВсе");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИмяДляВхода(Форма, ПриИзмененииНаименования = Ложь)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Форма.ПользовательИБСуществует Тогда
		Возврат;
	КонецЕсли;
	
	КраткоеИмя = ПользователиСлужебныйКлиентСервер.ПолучитьКраткоеИмяПользователяИБ(
		Форма.ТекущееПредставлениеОбъектаАвторизации);
	
	Если Элементы.ИмяПереключениеОтметкиНезаполненного.ТекущаяСтраница = Элементы.ИмяБезОтметкиНезаполненного Тогда
		Если Форма.ПользовательИнфБазыИмя = КраткоеИмя Тогда
			Форма.ПользовательИнфБазыИмя = "";
		КонецЕсли;
	Иначе
		
		Если ПриИзмененииНаименования
		 Или Не ЗначениеЗаполнено(Форма.ПользовательИнфБазыИмя) Тогда
			
			Форма.ПользовательИнфБазыИмя = КраткоеИмя;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АутентификацияПриИзменении()
	
	УстановитьДоступностьСвойств();
	
	Если НЕ ПользовательИнфБазыАутентификацияOpenID
	   И НЕ ПользовательИнфБазыАутентификацияСтандартная Тогда
	
		ВходВПрограммуРазрешен = Ложь;
		
	ИначеЕсли Не ВходВПрограммуРазрешен Тогда
		ВходВПрограммуРазрешен = ВходВПрограммуРазрешенЗначениеПрямогоИзменения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДействияВФорме()
	
	ДействияВФорме = Новый Структура;
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("Роли", "");
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("СвойстваПользователяИБ", "");
	
	// "", "Просмотр", "Редактирование".
	ДействияВФорме.Вставить("СвойстваЭлемента", "Просмотр");
	
	Если УровеньДоступа.ИзменениеТекущего Или УровеньДоступа.УправлениеСписком Тогда
		ДействияВФорме.СвойстваПользователяИБ = "Редактирование";
	КонецЕсли;
	
	Если УровеньДоступа.УправлениеСписком Тогда
		ДействияВФорме.СвойстваЭлемента = "Редактирование";
	КонецЕсли;
	
	Если УровеньДоступа.ПолныеПрава Тогда
		ДействияВФорме.Роли = "Редактирование";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И НЕ ЗначениеЗаполнено(Объект.ОбъектАвторизации) Тогда
		
		ДействияВФорме.СвойстваЭлемента = "Редактирование";
	КонецЕсли;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.Пользователи\ПриОпределенииДействийВФорме");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииДействийВФорме(Объект.Ссылка, ДействияВФорме);
	КонецЦикла;
	
	ПользователиПереопределяемый.ИзменитьДействияВФорме(Объект.Ссылка, ДействияВФорме);
	
	// Проверка имен действий в форме.
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.Роли + ",") = 0 Тогда
		ДействияВФорме.Роли = "";
		
	ИначеЕсли ДействияВФорме.Роли = "Редактирование"
	        И ПользователиСлужебный.ЗапретРедактированияРолей() Тогда
		
		ДействияВФорме.Роли = "Просмотр";
	КонецЕсли;
	
	Если Найти(", Просмотр, ПросмотрВсех, Редактирование, РедактированиеСвоих, РедактированиеВсех,",
	           ", " + ДействияВФорме.СвойстваПользователяИБ + ",") = 0 Тогда
		
		ДействияВФорме.СвойстваПользователяИБ = "";
		
	Иначе // Поддержка обратной совместимости.
		Если Найти(ДействияВФорме.СвойстваПользователяИБ, "Просмотр") Тогда
			ДействияВФорме.СвойстваПользователяИБ = "Просмотр";
			
		ИначеЕсли Найти(ДействияВФорме.СвойстваПользователяИБ, "Редактирование") Тогда
			ДействияВФорме.СвойстваПользователяИБ = "Редактирование";
		КонецЕсли;
	КонецЕсли;
	
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.СвойстваЭлемента + ",") = 0 Тогда
		ДействияВФорме.СвойстваЭлемента = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеПользователяИБ()
	
	Если УровеньДоступа.УправлениеСписком
	   И ДействияВФорме.СвойстваЭлемента = "Редактирование" Тогда
		
		ПользовательИнфБазыПолноеИмя = Объект.Наименование;
	КонецЕсли;
	
	Если УровеньДоступа.АдминистраторСистемы
	 Или УровеньДоступа.ПолныеПрава Тогда
		
		Результат = Пользователи.НовоеОписаниеПользователяИБ();
		Пользователи.СкопироватьСвойстваПользователяИБ(
			Результат,
			ЭтотОбъект,
			,
			"УникальныйИдентификатор,
			|Роли",
			"ПользовательИнфБазы");
		
		Результат.Вставить("ВходВПрограммуРазрешен", ВходВПрограммуРазрешен);
		
	Иначе
		Результат = Новый Структура;
		
		Если УровеньДоступа.ИзменениеТекущего Тогда
			Результат.Вставить("Пароль", ПользовательИнфБазыПароль);
			Результат.Вставить("Язык",   ПользовательИнфБазыЯзык);
		КонецЕсли;
		
		Если УровеньДоступа.УправлениеСписком Тогда
			Результат.Вставить("ВходВПрограммуРазрешен",  ВходВПрограммуРазрешен);
			Результат.Вставить("ЗапрещеноИзменятьПароль", ПользовательИнфБазыЗапрещеноИзменятьПароль);
			Результат.Вставить("Язык",                    ПользовательИнфБазыЯзык);
			Результат.Вставить("ПолноеИмя",               ПользовательИнфБазыПолноеИмя);
		КонецЕсли;
		
		Если УровеньДоступа.НастройкиДляВхода Тогда
			Результат.Вставить("АутентификацияСтандартная", ПользовательИнфБазыАутентификацияСтандартная);
			Результат.Вставить("Имя",                       ПользовательИнфБазыИмя);
			Результат.Вставить("Пароль",                    ПользовательИнфБазыПароль);
			Результат.Вставить("АутентификацияOpenID",      ПользовательИнфБазыАутентификацияOpenID);
		КонецЕсли;
	КонецЕсли;
	Результат.Вставить("ПодтверждениеПароля", ПодтверждениеПароля);
	
	Если УровеньДоступа.НастройкиДляВхода
	   И Не ПользователиСлужебный.ЗапретРедактированияРолей()
	   И Объект.УстановитьРолиНепосредственно Тогда
		
		ТекущиеРоли = ПользовательИнфБазыРоли.Выгрузить(, "Роль").ВыгрузитьКолонку("Роль");
		Результат.Вставить("Роли", ТекущиеРоли);
	КонецЕсли;
	
	Если УровеньДоступа.УправлениеСписком Тогда
		Результат.Вставить("ПоказыватьВСпискеВыбора", Ложь);
		Результат.Вставить("РежимЗапуска", "Авто");
	КонецЕсли;
	
	Если УровеньДоступа.ПолныеПрава Тогда
		Результат.Вставить("АутентификацияОС", Ложь);
		Результат.Вставить("ПользовательОС", "");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(Форма, Объект)
	
	Если Объект.ОбъектАвторизации = Неопределено Тогда
		Объект.ОбъектАвторизации = Форма.ТипОбъектовАвторизации;
	КонецЕсли;
	
	Если Форма.ТекущееПредставлениеОбъектаАвторизации <> Строка(Объект.ОбъектАвторизации) Тогда
		Форма.ТекущееПредставлениеОбъектаАвторизации = Строка(Объект.ОбъектАвторизации);
		ОбновитьИмяДляВхода(Форма, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображаемыйТипПользователя()
	
	Если Объект.ОбъектАвторизации <> Неопределено Тогда
		Элементы.ОбъектАвторизации.Заголовок = Метаданные.НайтиПоТипу(ТипЗнч(Объект.ОбъектАвторизации)).ПредставлениеОбъекта;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОЗаписиСПустымСпискомРолей(Ответ, ПараметрыЗаписи) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыЗаписи.Вставить("СПустымСпискомРолей");
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка пользователя ИБ.

&НаСервере
Процедура ПрочитатьРолиПользователяИБ()
	
	СвойстваПользователяИБ = Неопределено;
	
	Пользователи.ПрочитатьПользователяИБ(
		Объект.ИдентификаторПользователяИБ, СвойстваПользователяИБ);
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", СвойстваПользователяИБ.Роли);
	
КонецПроцедуры

&НаСервере
Функция НачальноеОписаниеПользователяИБ()
	
	ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
		ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
	КонецЕсли;
	ОписаниеПользователяИБ.Роли = Новый Массив;
	
	Возврат ОписаниеПользователяИБ;
	
КонецФункции

&НаСервере
Процедура ПрочитатьПользователяИБ(ПриКопированииЭлемента = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пароль              = "";
	ПодтверждениеПароля = "";
	ПрочитанныеСвойства      = Неопределено;
	ОписаниеПользователяИБ   = НачальноеОписаниеПользователяИБ();
	ПользовательИБСуществует = Ложь;
	ПользовательИБОсновной   = Ложь;
	ВходВПрограммуРазрешен   = Ложь;
	ВходВПрограммуРазрешенЗначениеПрямогоИзменения = Ложь;
	
	Если ПриКопированииЭлемента Тогда
		
		Если Пользователи.ПрочитатьПользователяИБ(
		         Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ,
		         ПрочитанныеСвойства) Тогда
			
			// Сопоставление пользователя ИБ с пользователем в справочнике.
			Если Пользователи.ВходВПрограммуРазрешен(ПрочитанныеСвойства) Тогда
				ВходВПрограммуРазрешен = Истина;
				ВходВПрограммуРазрешенЗначениеПрямогоИзменения = Истина;
			КонецЕсли;
			
			// Копирование свойств и ролей пользователяИБ.
			ЗаполнитьЗначенияСвойств(
				ОписаниеПользователяИБ,
				ПрочитанныеСвойства,
				"ЗапрещеноИзменятьПароль,
				|РежимЗапуска" + ?(Не Элементы.ПользовательИнфБазыЯзык.Видимость, "", ",
				|Язык") + ?(ПользователиСлужебный.ЗапретРедактированияРолей(), "", ",
				|Роли"));
		КонецЕсли;
		Объект.ИдентификаторПользователяИБ = Неопределено;
	Иначе
		Если Пользователи.ПрочитатьПользователяИБ(
		       Объект.ИдентификаторПользователяИБ, ПрочитанныеСвойства) Тогда
		
			ПользовательИБСуществует = Истина;
			ПользовательИБОсновной = Истина;
			
		ИначеЕсли Параметры.Свойство("ИдентификаторПользователяИБ")
		        И ЗначениеЗаполнено(Параметры.ИдентификаторПользователяИБ) Тогда
			
			Объект.ИдентификаторПользователяИБ = Параметры.ИдентификаторПользователяИБ;
			
			Если Пользователи.ПрочитатьПользователяИБ(
			       Объект.ИдентификаторПользователяИБ, ПрочитанныеСвойства) Тогда
				
				ПользовательИБСуществует = Истина;
				Если Объект.Наименование <> ПрочитанныеСвойства.ПолноеИмя Тогда
					ПрочитанныеСвойства.ПолноеИмя = Объект.Наименование;
					Модифицированность = Истина;
				КонецЕсли;
				Если ПрочитанныеСвойства.АутентификацияОС Тогда
					ПрочитанныеСвойства.АутентификацияОС = Ложь;
					Модифицированность = Истина;
				КонецЕсли;
				Если ЗначениеЗаполнено(ПрочитанныеСвойства.ПользовательОС) Тогда
					ПрочитанныеСвойства.ПользовательОС = "";
					Модифицированность = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ПользовательИБСуществует Тогда
			
			Если Не Элементы.ПользовательИнфБазыЯзык.Видимость Тогда
				ПрочитанныеСвойства.Язык = ОписаниеПользователяИБ.Язык;
			КонецЕсли;
			
			Если Пользователи.ВходВПрограммуРазрешен(ПрочитанныеСвойства) Тогда
				ВходВПрограммуРазрешен = Истина;
				ВходВПрограммуРазрешенЗначениеПрямогоИзменения = Истина;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(
				ОписаниеПользователяИБ,
				ПрочитанныеСвойства,
				"Имя,
				|ПолноеИмя,
				|АутентификацияOpenID,
				|АутентификацияСтандартная,
				|ПоказыватьВСпискеВыбора,
				|ЗапрещеноИзменятьПароль,
				|АутентификацияОС,
				|ПользовательОС,
				|РежимЗапуска,
				|РежимЗапуска" + ?(Не Элементы.ПользовательИнфБазыЯзык.Видимость, "", ",
				|Язык") + ?(ПользователиСлужебный.ЗапретРедактированияРолей(), "", ",
				|Роли"));
			
			Если ПрочитанныеСвойства.ПарольУстановлен Тогда
				Пароль              = "**********";
				ПодтверждениеПароля = "**********";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Пользователи.СкопироватьСвойстваПользователяИБ(
		ЭтотОбъект,
		ОписаниеПользователяИБ,
		,
		"УникальныйИдентификатор,
		|Роли",
		"ПользовательИнфБазы");
	
	Если ПользовательИБОсновной И Не ВходВПрограммуРазрешен Тогда
		ХранимыеСвойства = ПользователиСлужебный.ХранимыеСвойстваПользователяИБ(Объект.Ссылка);
		ПользовательИнфБазыАутентификацияOpenID      = ХранимыеСвойства.АутентификацияOpenID;
		ПользовательИнфБазыАутентификацияСтандартная = ХранимыеСвойства.АутентификацияСтандартная;
	КонецЕсли;
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", ОписаниеПользователяИБ.Роли);
	
	ПриЧтенииВходВПрограммуРазрешен = ВходВПрограммуРазрешен;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи = Неопределено)
	
	// Проверка соответствия свойства ПолноеИмя пользователяИБ и
	// реквизита Наименование внешнего пользователя. А также значений свойств по умолчанию.
	
	ПоказатьНесоответствие = Истина;
	ПоказатьКомандыУстраненияРазличий = Ложь;
	
	Если НЕ ПользовательИБСуществует Тогда
		ПоказатьНесоответствие = Ложь;
		
	ИначеЕсли Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПользовательИнфБазыПолноеИмя = Объект.Наименование;
		ПоказатьНесоответствие = Ложь;
		
	ИначеЕсли УровеньДоступа.УправлениеСписком Тогда
		
		УточнениеСвойств = Новый Массив;
		ЕстьРазличияУстранимыеБезАдминистратора = Ложь;
		
		Если ПользовательИнфБазыАутентификацияОС <> Ложь Тогда
			УточнениеСвойств.Добавить(НСтр("ru = 'Аутентификация ОС (включена)'"));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(УточнениеСвойств) Тогда
			ПоказатьКомандыУстраненияРазличий =
				  УровеньДоступа.НастройкиДляВхода
				И ДействияВФорме.СвойстваПользователяИБ = "Редактирование";
		КонецЕсли;
		
		Если ПользовательИнфБазыПолноеИмя <> Объект.Наименование Тогда
			ЕстьРазличияУстранимыеБезАдминистратора = Истина;
			
			УточнениеПолногоИмени = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Полное имя ""%1""'"), ПользовательИнфБазыПолноеИмя);
			
			УточнениеСвойств.Вставить(0, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Полное имя ""%1""'"), ПользовательИнфБазыПолноеИмя));
		КонецЕсли;
		
		Если ПользовательИнфБазыПользовательОС <> "" Тогда
			УточнениеСвойств.Добавить(НСтр("ru = 'Пользователь ОС (указан)'"));
		КонецЕсли;
		
		Если ПользовательИнфБазыПоказыватьВСпискеВыбора Тогда
			ЕстьРазличияУстранимыеБезАдминистратора = Истина;
			УточнениеСвойств.Добавить(НСтр("ru = 'Показывать в списке выбора (включено)'"));
		КонецЕсли;
		
		Если ПользовательИнфБазыРежимЗапуска <> "Авто" Тогда
			ЕстьРазличияУстранимыеБезАдминистратора = Истина;
			УточнениеСвойств.Добавить(НСтр("ru = 'Режим запуска (не Авто)'"));
		КонецЕсли;
		
		Если УточнениеСвойств.Количество() > 0 Тогда
			СтрокаУточненияСвойств = "";
			ТекущаяСтрока = "";
			Для каждого УточнениеСвойства Из УточнениеСвойств Цикл
				Если СтрДлина(ТекущаяСтрока + УточнениеСвойства) > 90 Тогда
					СтрокаУточненияСвойств = СтрокаУточненияСвойств + СокрП(ТекущаяСтрока) + ", " + Символы.ПС;
					ТекущаяСтрока = "";
				КонецЕсли;
				ТекущаяСтрока = ТекущаяСтрока + ?(ЗначениеЗаполнено(ТекущаяСтрока), ", ", "") + УточнениеСвойства;
			КонецЦикла;
			Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда
				СтрокаУточненияСвойств = СтрокаУточненияСвойств + ТекущаяСтрока;
			КонецЕсли;
			Элементы.СвойстваПояснениеНесоответствия.Заголовок =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Следующие свойства пользователя информационной базы отличаются от указанных в этой форме:
					           |%1.'"), СтрокаУточненияСвойств)
				+ Символы.ПС
				+ ?(ПоказатьКомандыУстраненияРазличий Или ЕстьРазличияУстранимыеБезАдминистратора,
					НСтр("ru = 'Нажмите ""Записать"", чтобы устранить различия и не выводить это предупреждение.'"),
					НСтр("ru = 'Обратитесь к администратору, чтобы устранить различия.'"));
		Иначе
			ПоказатьНесоответствие = Ложь;
		КонецЕсли;
	Иначе
		ПоказатьНесоответствие = Ложь;
	КонецЕсли;
	
	Элементы.СвойстваОбработкаНесоответствия.Видимость = ПоказатьНесоответствие;
	
	// Определение сопоставления несуществующего пользователя ИБ с пользователем в справочнике.
	ЕстьНовоеСопоставлениеСНесуществующимПользователемИБ =
		НЕ ПользовательИБСуществует И ЗначениеЗаполнено(Объект.ИдентификаторПользователяИБ);
	
	Если ПараметрыЗаписи <> Неопределено
	   И ЕстьСопоставлениеСНесуществующимПользователемИБ
	   И НЕ ЕстьНовоеСопоставлениеСНесуществующимПользователемИБ Тогда
		
		ПараметрыЗаписи.Вставить("ОчищеноСопоставлениеСНесуществующимПользователемИБ", Объект.Ссылка);
	КонецЕсли;
	ЕстьСопоставлениеСНесуществующимПользователемИБ = ЕстьНовоеСопоставлениеСНесуществующимПользователемИБ;
	
	Если УровеньДоступа.УправлениеСписком Тогда
		Элементы.СопоставлениеОбработкаНесоответствия.Видимость = ЕстьСопоставлениеСНесуществующимПользователемИБ;
	Иначе
		// Сопоставление не может быть изменено.
		Элементы.СопоставлениеОбработкаНесоответствия.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Начальное заполнение, проверка заполнения, доступность свойств

&НаСервере
Процедура УстановитьДоступностьСвойств()
	
	// Настройка возможности изменения.
	Элементы.ОбъектАвторизации.ТолькоПросмотр
		=   ДействияВФорме.СвойстваЭлемента <> "Редактирование"
		ИЛИ ОбъектАвторизацииЗаданПриОткрытии
		ИЛИ   ЗначениеЗаполнено(Объект.Ссылка)
		    И ЗначениеЗаполнено(Объект.ОбъектАвторизации);
	
	Элементы.Недействителен.ТолькоПросмотр =
		Не (ДействияВФорме.СвойстваЭлемента = "Редактирование" И УровеньДоступа.УправлениеСписком);
	
	Элементы.ОсновныеСвойства.ТолькоПросмотр =
		Не (  ДействияВФорме.СвойстваПользователяИБ = "Редактирование"
		    И (УровеньДоступа.УправлениеСписком Или УровеньДоступа.ИзменениеТекущего));
	
	Элементы.ВходВПрограммуРазрешен.ТолькоПросмотр =
		Не (  Элементы.ОсновныеСвойства.ТолькоПросмотр = Ложь
		    И (    УровеньДоступа.ПолныеПрава
		       Или УровеньДоступа.УправлениеСписком И ПриЧтенииВходВПрограммуРазрешен));
	
	Элементы.ПользовательИнфБазыИмя1.ТолькоПросмотр                      = Не УровеньДоступа.НастройкиДляВхода;
	Элементы.ПользовательИнфБазыИмя2.ТолькоПросмотр                      = Не УровеньДоступа.НастройкиДляВхода;
	Элементы.ПользовательИнфБазыАутентификацияСтандартная.ТолькоПросмотр = Не УровеньДоступа.НастройкиДляВхода;
	Элементы.ПользовательИнфБазыАутентификацияOpenID.ТолькоПросмотр      = Не УровеньДоступа.НастройкиДляВхода;
	Элементы.УстановитьРолиНепосредственно.ТолькоПросмотр                = Не УровеньДоступа.НастройкиДляВхода;
	
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.ТолькоПросмотр = Не УровеньДоступа.УправлениеСписком;
	
	Элементы.Пароль.ТолькоПросмотр =
		Не (    УровеньДоступа.НастройкиДляВхода
		    Или УровеньДоступа.ИзменениеТекущего
		      И Не ПользовательИнфБазыЗапрещеноИзменятьПароль);
	
	Элементы.ПодтверждениеПароля.ТолькоПросмотр = Элементы.Пароль.ТолькоПросмотр;
	
	ОбработатьИнтерфейсРолей(
		"УстановитьТолькоПросмотрРолей",
		    ЗапретРедактированияРолей
		Или ДействияВФорме.Роли <> "Редактирование"
		Или Не Объект.УстановитьРолиНепосредственно
		Или Не УровеньДоступа.НастройкиДляВхода);
	
	Элементы.Комментарий.ТолькоПросмотр =
		Не (ДействияВФорме.СвойстваЭлемента = "Редактирование" И УровеньДоступа.УправлениеСписком);
	
	// Настройка необходимости заполнения.
	Если ТребуетсяЗаписьПользователяИБ(ЭтотОбъект, Ложь) Тогда
		НоваяСтраница = Элементы.ИмяСОтметкойНезаполненного;
	Иначе
		НоваяСтраница = Элементы.ИмяБезОтметкиНезаполненного;
	КонецЕсли;
	
	Если Элементы.ИмяПереключениеОтметкиНезаполненного.ТекущаяСтраница <> НоваяСтраница Тогда
		Элементы.ИмяПереключениеОтметкиНезаполненного.ТекущаяСтраница = НоваяСтраница;
	КонецЕсли;
	ОбновитьИмяДляВхода(ЭтотОбъект);
	
	// Настройка доступности связанных элементов.
	Элементы.ВходВПрограммуРазрешен.Доступность         = НЕ Объект.Недействителен;
	Элементы.ОсновныеСвойства.Доступность               = НЕ Объект.Недействителен;
	Элементы.РедактированиеИлиПросмотрРолей.Доступность = НЕ Объект.Недействителен;
	
	Элементы.Пароль.Доступность              = ПользовательИнфБазыАутентификацияСтандартная;
	Элементы.ПодтверждениеПароля.Доступность = ПользовательИнфБазыАутентификацияСтандартная;
	
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.Доступность
		= ПользовательИнфБазыАутентификацияСтандартная;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяЗаписьПользователяИБ(Форма, УчитыватьСтандартноеИмя = Истина)
	
	Если Форма.ДействияВФорме.СвойстваПользователяИБ <> "Редактирование" Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Шаблон = Форма.НачальноеОписаниеПользователяИБ;
	
	ТекущееИмя = "";
	Если Не УчитыватьСтандартноеИмя Тогда
		КраткоеИмя = ПользователиСлужебныйКлиентСервер.ПолучитьКраткоеИмяПользователяИБ(
			Форма.ТекущееПредставлениеОбъектаАвторизации);
		
		Если Форма.ПользовательИнфБазыИмя = КраткоеИмя Тогда
			ТекущееИмя = КраткоеИмя;
		КонецЕсли;
	КонецЕсли;
	
	Если Форма.ПользовательИБСуществует
	 ИЛИ Форма.ВходВПрограммуРазрешен
	 ИЛИ Форма.ПользовательИнфБазыИмя                       <> ТекущееИмя
	 ИЛИ Форма.ПользовательИнфБазыАутентификацияСтандартная <> Шаблон.АутентификацияСтандартная
	 ИЛИ Форма.ПользовательИнфБазыЗапрещеноИзменятьПароль   <> Шаблон.ЗапрещеноИзменятьПароль
	 ИЛИ Форма.Пароль <> ""
	 ИЛИ Форма.ПодтверждениеПароля <> ""
	 ИЛИ Форма.ПользовательИнфБазыАутентификацияOpenID <> Шаблон.АутентификацияOpenID
	 ИЛИ Форма.ПользовательИнфБазыЯзык                 <> Шаблон.Язык
	 ИЛИ Форма.ПользовательИнфБазыРоли.Количество() <> 0 Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаСервере
Процедура ОбработатьИнтерфейсРолей(Действие, ОсновнойПараметр = Неопределено)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОсновнойПараметр",      ОсновнойПараметр);
	ПараметрыДействия.Вставить("Форма",                 ЭтотОбъект);
	ПараметрыДействия.Вставить("КоллекцияРолей",        ПользовательИнфБазыРоли);
	ПараметрыДействия.Вставить("ТипПользователей",      Перечисления.ТипыПользователей.ВнешнийПользователь);
	ПараметрыДействия.Вставить("СкрытьРольПолныеПрава", Истина);
	
	ПользователиСлужебный.ОбработатьИнтерфейсРолей(Действие, ПараметрыДействия);
	
КонецПроцедуры

#КонецОбласти
