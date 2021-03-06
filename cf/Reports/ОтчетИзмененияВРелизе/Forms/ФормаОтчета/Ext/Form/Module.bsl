﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ПараметрЗапуска) Тогда
		СформироватьОтчетНаСервере(ПараметрЗапуска);
	Иначе
		Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетНаСервере(ПараметрЗапуска)
	
	Релиз = Справочники.Релизы.НайтиПоКоду(ПараметрЗапуска);
	
	Если Релиз.Пустая() Тогда
		Сообщить("Не найден релиз версии "+ПараметрЗапуска);
		Возврат;
	Иначе
		Если Релиз.Уровень() > 0 Тогда
			РелизПараметр = Релиз.Родитель;
		Иначе
			РелизПараметр = Релиз;
		КонецЕсли; 
	КонецЕсли; 
	
	ЭтотОтчет = РеквизитФормыВЗначение("Отчет");
	
	ЭтотОтчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Релиз", РелизПараметр);
	
	ЭтотОтчет.СкомпоноватьРезультат(Результат);
	
КонецПроцедуры   

