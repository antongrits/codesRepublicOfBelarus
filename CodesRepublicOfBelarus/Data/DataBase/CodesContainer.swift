//
//  CodesContainer.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 30.03.24.
//

import SwiftUI
import SwiftData

actor CodesContainer {
    @EnvironmentObject var errorViewModel: ErrorViewModel
    
    @MainActor
    func create(isFirstLaunch: inout Bool) -> ModelContainer {
        do {
            let schema = Schema([CodeModel.self])
            let config = ModelConfiguration()
            let container = try ModelContainer(for: schema, configurations: config)
            if isFirstLaunch {
                let codes = CodesJSONDecoder.decode(from: "Codes")
                if codes.isEmpty == false {
                    codes.forEach { code in
                        container.mainContext.insert(CodeModel(id: code.id, name: code.name, desc: code.desc, imageName: imageName(for: code.name)))
                    }
                }
                isFirstLaunch = false
            }
            return container
        } catch {
            errorViewModel.errorModel = ErrorModel(error: error, guidance: "При возникновении этой ошибки, пожалуйста, напишите на email antongric07@gmail.com")
            return try! ModelContainer(for: Schema([CodeModel.self]), configurations: ModelConfiguration())
        }
    }
    
    @MainActor
    func imageName(for codeName: String) -> String {
        switch codeName {
        case "Гражданский кодекс Республики Беларусь":
            return "civilCode"
        case "Трудовой кодекс Республики Беларусь":
            return "laborCode"
        case "Хозяйственный процессуальный кодекс Республики Беларусь":
            return "economicProceduralCode"
        case "Гражданский процессуальный кодекс Республики Беларусь":
            return "civilProcedureCode"
        case "Налоговый кодекс Республики Беларусь (Особенная часть)", "Налоговый кодекс Республики Беларусь (Общая часть)":
            return "taxCode"
        case "Уголовный кодекс Республики Беларусь", "Уголовно-процессуальный кодекс Республики Беларусь", "Уголовно-исполнительный кодекс Республики Беларусь":
            return "criminalCode"
        case "Кодекс Республики Беларусь о браке и семье":
            return "familyCode"
        case "Процессуально-исполнительный кодекс Республики Беларусь об административных правонарушениях", "Кодекс Республики Беларусь об административных правонарушениях":
            return "administrativeOffencesCode"
        case "Жилищный кодекс Республики Беларусь":
            return "housingCode"
        case "Кодекс Республики Беларусь об образовании":
            return "educationCode"
        case "Бюджетный кодекс Республики Беларусь":
            return "budgetCode"
        case "Кодекс Республики Беларусь о судоустройстве и статусе судей":
            return "judgesCode"
        case "Кодекс Республики Беларусь о земле":
            return "landCode"
        case "Банковский кодекс Республики Беларусь":
            return "bankCode"
        case "Избирательный кодекс Республики Беларусь":
            return "electoralCode"
        case "Кодэкс Рэспублiкi Беларусь аб культуры":
            return "cultureCode"
        case "Лесной кодекс Республики Беларусь":
            return "forestCode"
        case "Водный кодекс Республики Беларусь":
            return "waterCode"
        case "Воздушный кодекс Республики Беларусь":
            return "airCode"
        case "Кодекс Республики Беларусь о недрах":
            return "subsoilCode"
        case "Кодекс внутреннего водного транспорта Республики Беларусь":
            return "waterTransportCode"
        case "Кодекс торгового мореплавания Республики Беларусь":
            return "shippingCode"
        case "Кодекс Республики Беларусь об архитектурной, градостроительной и строительной деятельности":
            return "buildingCode"
        default:
            return "newCode"
        }
    }
}
