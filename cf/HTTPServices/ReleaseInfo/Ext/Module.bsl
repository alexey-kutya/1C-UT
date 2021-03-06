﻿Функция GetInfo(ReleaseID)
	
	Позиция_ = СтрНайти(ReleaseID, "_");
	ReleaseID = ?(Позиция_ = 0, ReleaseID, Лев(ReleaseID, Позиция_-1));
	
	Релиз = Справочники.Релизы.НайтиПоКоду(ReleaseID);
	
	Если Релиз.Пустая() Тогда
		Возврат Неопределено;
	Иначе
		Если Релиз.Уровень() > 0 Тогда
			РелизПараметр = Релиз.Родитель;
		Иначе
			РелизПараметр = Релиз;
		КонецЕсли; 
	КонецЕсли; 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИзменениеКонфигурации.Релиз.Код КАК Релиз,
		|	ИзменениеКонфигурации.Заказчик.ФизЛицо.Наименование КАК Заказчик,
		|	ИзменениеКонфигурации.ДокументОснование.Номер КАК НомерЗаявки,
		|	ВЫРАЗИТЬ(ИзменениеКонфигурации.СутьИзменений КАК СТРОКА(1000)) КАК СутьИзменений
		|ИЗ
		|	Документ.ИзменениеКонфигурации КАК ИзменениеКонфигурации
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ИзменениеКонфигурации.Заказчик.ФизЛицо = Сотрудники.ФизЛицо
		|ГДЕ
		|	ИзменениеКонфигурации.Релиз В ИЕРАРХИИ(&Релиз)
		|	И Сотрудники.Ссылка ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	ИзменениеКонфигурации.Заказчик.ФизЛицо.Наименование,
		|	ИзменениеКонфигурации.ДокументОснование.Номер,
		|	ВЫРАЗИТЬ(ИзменениеКонфигурации.СутьИзменений КАК СТРОКА(1000)),
		|	ИзменениеКонфигурации.Релиз.Код
		|ИТОГИ ПО
		|	Релиз,
		|	Заказчик";
	
	Запрос.УстановитьПараметр("Релиз", РелизПараметр);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРелиз = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ReleaseInfo = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.roust.com/ReleaseInfo", "ReleaseInfo"));
	
	Пока ВыборкаРелиз.Следующий() Цикл
		
		Release = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.roust.com/ReleaseInfo", "Release"));
	    Release.Identity = ВыборкаРелиз.Релиз;
	
		ВыборкаЗаказчик = ВыборкаРелиз.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
		Пока ВыборкаЗаказчик.Следующий() Цикл
			
			Initiator = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.roust.com/ReleaseInfo", "Initiator"));
		    Initiator.Name = ВыборкаЗаказчик.Заказчик;
	
			ВыборкаДетальныеЗаписи = ВыборкаЗаказчик.Выбрать();
	
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				Request = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.roust.com/ReleaseInfo", "Request"));
				Request.RequestNumber = ВыборкаДетальныеЗаписи.НомерЗаявки;
				Request.Description = ВыборкаДетальныеЗаписи.СутьИзменений;
				Initiator.Request.Добавить(Request);
				
			КонецЦикла;
			Release.Initiator.Добавить(Initiator);
		КонецЦикла;
		ReleaseInfo.Release.Добавить(Release);
	КонецЦикла;
	
	Возврат ReleaseInfo;

КонецФункции

Функция ReleaseInfoGET(Запрос)
	
	ReleaseID = Запрос.ПараметрыURL["ReleaseID"];
	ReleaseInfo = GetInfo(ReleaseID);
	
	Если ReleaseInfo = Неопределено Тогда
		Результат = "Не найдены данные по релизу "+ReleaseID;
	Иначе
		ЗаписьXML  = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку();
		ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ReleaseInfo, "ReleaseInfo");
		СтрокаXML = ЗаписьXML.Закрыть();
		СтрокаXML = СтрЗаменить(СтрокаXML, "xmlns=", "xmlns:ri=");
		
		ДвоичныеДанныеXSL = ПолучитьОбщийМакет("ReleaseInfoXSL");
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xsl");
		ДвоичныеДанныеXSL.Записать(ИмяВременногоФайла);
		
		Преобразование = Новый ПреобразованиеXSL;
		Преобразование.ЗагрузитьИзФайла(ИмяВременногоФайла);
		Результат = Преобразование.ПреобразоватьИзСтроки(СтрокаXML);
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли; 
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "text/html;charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(Результат);
	
	Возврат Ответ;
	
КонецФункции
