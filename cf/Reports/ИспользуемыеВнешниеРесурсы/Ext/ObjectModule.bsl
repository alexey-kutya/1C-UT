﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытийОбъекта

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ФункцииОтчетовКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.ФормироватьСразу = Истина;
	Настройки.ВыводитьСуммуВыделенныхЯчеек = Ложь;
	
КонецПроцедуры

// Вызывается при выполнении отчета с помощью метода СкомпоноватьРезультат().
//
// Параметры:
//  ДокументРезультат - ТабличныйДокумент - документ, в который выводится результат,
//  ДанныеРасшифровки - Произвольный - переменная, в которую необходимо поместить
//    данные расшифровки,
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения
//    стандартной (системной) обработки события.
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДокументРезультат.Очистить();
	
	НачатьТранзакцию();
	
	Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
	Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Истина);
	
	Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ОчиститьПредоставленныеРазрешения();
	
	ЗапросыРазрешений = РаботаВБезопасномРежимеСлужебный.ЗапросыНаОбновлениеРазрешенийКонфигурации();
	
	ОперацииАдминистрирования = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ОперацииАдминистрированияВЗапросах(ЗапросыРазрешений);
	Дельта = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ДельтаИзмененийРазрешенийНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений);
	
	ОтменитьТранзакцию();
	
	Отчеты.ИспользуемыеВнешниеРесурсы.ЗаполнитьПредставлениеРезультатаПримененияЗапросовНаИспользованиеВнешнихРесурсов(
		ДокументРезультат, ОперацииАдминистрирования, Дельта, Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
