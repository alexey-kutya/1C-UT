Функция ПолучитьРезультатЗапроса(BaseIDArray)

	Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
	МассивБаз = Сериализатор.ПрочитатьXDTO(BaseIDArray);

    Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ
    	|	ИнформационныеБазы.BaseID,
    	|	ИнформационныеБазы.Наименование КАК BaseDescription,
    	|	ИнформационныеБазы.WSСсылка КАК LocationWSDL,
    	|	ИнформационныеБазы.WSПользователь КАК User,
    	|	ИнформационныеБазы.WSПароль КАК Password
    	|ИЗ
    	|	Справочник.ИнформационныеБазы КАК ИнформационныеБазы
    	|ГДЕ
    	|	ИнформационныеБазы.BaseID <> """"
    	|	И Условие";
	
	Если МассивБаз.Количество() Тогда
	    Условие = "ИнформационныеБазы.BaseID В(&МассивБаз)";
		Запрос.УстановитьПараметр("МассивБаз", МассивБаз);
	Иначе
	    Условие = "ИСТИНА";
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "Условие", Условие);
    
    Возврат Запрос.Выполнить();

КонецФункции // ПолучитьРезультатЗапроса()
 

Функция GetXML(BaseIDArray)
	
    РезультатЗапроса = ПолучитьРезультатЗапроса(BaseIDArray);
    
    Выборка = РезультатЗапроса.Выбрать();
    
    ЗаписьXML  = Новый ЗаписьXML;
    ЗаписьXML.УстановитьСтроку();
    ЗаписьXML.ЗаписатьОбъявлениеXML();
 
    ConnectionParametersWS = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.roust.com/ConnectionParametersWS", "ConnectionParametersWS"));
    
    Пока Выборка.Следующий() Цикл
    	
    	SetOfParameters = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.roust.com/ConnectionParametersWS", "SetOfParameters"));
    	SetOfParameters.BaseID = Выборка.BaseID;
    	SetOfParameters.BaseDescription = Выборка.Наименование;
    	SetOfParameters.LocationWSDL = Выборка.WSСсылка;
    	SetOfParameters.User = Выборка.WSПользователь;
    	SetOfParameters.Password = Выборка.WSПароль;
        	
    	ConnectionParametersWS.SetOfParameters.Добавить(SetOfParameters);
    КонецЦикла;
    
	Возврат ConnectionParametersWS;
	
КонецФункции

Функция GetValueTable(BaseIDArray)
	
	РезультатЗапроса = ПолучитьРезультатЗапроса(BaseIDArray);
	
	Возврат СериализаторXDTO.ЗаписатьXDTO(РезультатЗапроса.Выгрузить());
	
КонецФункции
