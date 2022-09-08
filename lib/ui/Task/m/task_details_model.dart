import 'dart:convert';

class TaskDetailsModel {
  List<DetailsModel> qa_qc_package;
  SurfaceModel surface_preparation_package;
  SoftcutApplicationModel shotcrete_application_package;
  MonitoringModel applied_monitoring_package;
  EquipmentCleaningModel completion_equipment_cleaning_package;
  ChemicalAddedModel chemical_added;
  FiberAddedModel fiber_added;
  String attachment_link;
  String signature;

  TaskDetailsModel.fromJson(Map<String, dynamic> json)
      : qa_qc_package = json['qa_qc_package'] == null
            ? []
            : jsonDecode(json['qa_qc_package'])
                .map<DetailsModel>((value) => DetailsModel.fromJson(value))
                .toList(),
        shotcrete_application_package =
            json["shotcrete_application_package"] == null
                ? SoftcutApplicationModel.fromJson({})
                : json["shotcrete_application_package"].toString().isEmpty
                ? SoftcutApplicationModel.fromJson({})
                : SoftcutApplicationModel.fromJson(
                    json["shotcrete_application_package"]),
        applied_monitoring_package = json["applied_monitoring_package"] == null
            ? MonitoringModel.fromJson({})
            : MonitoringModel.fromJson(json["applied_monitoring_package"]),
        completion_equipment_cleaning_package =
            json["completion_equipment_cleaning_package"] == null
                ? EquipmentCleaningModel.fromJson({})
                : EquipmentCleaningModel.fromJson(
                    json["completion_equipment_cleaning_package"]),
        chemical_added = json["chemical_added"] == null
            ? ChemicalAddedModel.fromJson({})
            : ChemicalAddedModel.fromJson(json["chemical_added"]),
        fiber_added = json["fiber_added"] == null
            ? FiberAddedModel.fromJson({})
            : FiberAddedModel.fromJson(json["fiber_added"]),
        attachment_link = json["attachment_link"] ?? "",
        signature = json["signature"] ?? "",
        surface_preparation_package =
            json["surface_preparation_package"] == null
                ? SurfaceModel.fromJson({})
                : SurfaceModel.fromJson(json["surface_preparation_package"]);

  List<String> toQA() {
    List<String> list = [];
    qa_qc_package.forEach((element) {
      list.add(jsonEncode(element.toMap()));
    });
    return list;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['qa_qc_package'] = toQA().toString();
    map['surface_preparation_package'] = surface_preparation_package.toMap();
    map['shotcrete_application_package'] =
        shotcrete_application_package.toMap();
    map['applied_monitoring_package'] = applied_monitoring_package.toMap();
    map['completion_equipment_cleaning_package'] =
        completion_equipment_cleaning_package.toMap();
    map['fiber_added'] = fiber_added.toMap();
    map['chemical_added'] = chemical_added.toMap();
    map['attachment_link'] = attachment_link;
    map['signature'] = signature;
    return map;
  }
}

class DetailsModel {
  dynamic date;
  dynamic time;
  dynamic name_id;
  dynamic name_id_name;
  dynamic docket_number;
  dynamic mix_design;
  dynamic mix_temperature;
  dynamic flow_slump_results;
  dynamic load;
  dynamic location;

  DetailsModel.fromJson(Map<String, dynamic> json)
      : date = json["date"]??"",
        time = json["time"] ?? "",
        name_id_name = json["name_id_name"] ?? "",
        location = json["location"] ?? "",
        docket_number = json["docket_number"] ?? "",
        mix_design = json["mix_design"] ?? "",
        mix_temperature = json["mix_temperature"] ?? "",
        flow_slump_results = json["flow_slump_results"] ?? "",
        name_id = json["name_id"] ?? "";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['date'] = date;
    map['time'] = time;
    map['name_id_name'] = name_id_name;
    map['location'] = location;
    map['docket_number'] = docket_number;
    map['mix_design'] = mix_design;
    map['mix_temperature'] = mix_temperature;
    map['flow_slump_results'] = flow_slump_results;
    map['name_id'] = name_id;
    return map;
  }
}

class SurfaceModel {
  String control_management;
  String membrane;
  dynamic surface_scaled;
  dynamic bolts_installed;
  dynamic anchors;
  dynamic mesh_installed;
  dynamic surface_washed;
  dynamic starter_bars;
  dynamic location;
  dynamic barriers;
  dynamic depth;

  SurfaceModel.fromJson(Map<String, dynamic> json)
      : control_management = json["control_management"] ?? "",
        membrane = json["membrane"] ?? "",
        bolts_installed = json["bolts_installed"] ?? "",
        location = json["location"] ?? "",
        anchors = json["anchors"] ?? "",
        mesh_installed = json["mesh_installed"] ?? "",
        surface_washed = json["surface_washed"] ?? "",
        starter_bars = json["starter_bars"] ?? "",
        barriers = json["barriers"] ?? "",
        depth = json["depth"] ?? "",
        surface_scaled = json["surface_scaled"] ?? "";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['control_management'] = control_management;
    map['membrane'] = membrane;
    map['bolts_installed'] = bolts_installed;
    map['location'] = location;
    map['anchors'] = anchors;
    map['mesh_installed'] = mesh_installed;
    map['surface_washed'] = surface_washed;
    map['starter_bars'] = starter_bars;
    map['barriers'] = barriers;
    map['depth'] = depth;
    map['surface_scaled'] = surface_scaled;
    return map;
  }
}

class SoftcutApplicationModel {
  String equipment;
  String name_id_nozzleman;
  dynamic ambient_temperature;
  dynamic methods_used;
  dynamic location_sprayed;
  dynamic chainage;
  dynamic bays;
  dynamic position;
  dynamic volume;
  dynamic accelerator;
  dynamic Thickness;
  dynamic time_completion;
  dynamic start_time;
  dynamic finish_requirements;
  dynamic primary;
  dynamic ibc;
  dynamic dump_volume;
  dynamic euipment_performance_date;
  dynamic euipment_performance_postion;
  dynamic equipment_number_of_hours;
  dynamic euipment_performance_push_key;

  SoftcutApplicationModel.fromJson(Map<String, dynamic> json)
      : equipment = json["equipment"] ?? "",
        name_id_nozzleman = json["name_id_nozzleman"] ?? "",
        methods_used = json["methods_used"] ?? "0",
        accelerator = json["accelerator"] ?? "0",
        location_sprayed = json["location_sprayed"] ?? "",
        chainage = json["chainage"] ?? "",
        bays = json["bays"] ?? "",
        position = json["position"] ?? "0",
        Thickness = json["Thickness"] ?? "",
        time_completion = json["time_completion"] ?? "",
        volume = json["volume"] ?? "",
        start_time = json["start_time"] ?? "",
        finish_requirements = json["finish_requirements"] ?? "0",
        primary = json["primary"] ?? "0",
        ibc = json["ibc"] ?? "",
        dump_volume = json["dump_volume"] ?? "",
        euipment_performance_postion =json["euipment_performance_postion"] ?? "0",
        euipment_performance_push_key =json["euipment_performance_push_key"] ?? "0",
        euipment_performance_date = json["euipment_performance_date"] ?? "",
        equipment_number_of_hours = json["equipment_number_of_hours"] ?? "",
        ambient_temperature = json["ambient_temperature"] ?? "";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['equipment'] = equipment;
    map['name_id_nozzleman'] = name_id_nozzleman;
    map['methods_used'] = methods_used;
    map['accelerator'] = accelerator.toString();
    map['location_sprayed'] = location_sprayed;
    map['chainage'] = chainage;
    map['bays'] = bays;
    map['position'] = position;
    map['Thickness'] = Thickness;
    map['time_completion'] = time_completion;
    map['volume'] = volume.toString();
    map['start_time'] = start_time;
    map['finish_requirements'] = finish_requirements;
    map['primary'] = primary;
    map['ibc'] = ibc;
    map['dump_volume'] = dump_volume;
    map['euipment_performance_postion'] = euipment_performance_postion;
    map['euipment_performance_date'] = euipment_performance_date;
    map['equipment_number_of_hours'] = equipment_number_of_hours;
    map['ambient_temperature'] = ambient_temperature;
    map['euipment_performance_push_key'] = euipment_performance_push_key;
    return map;
  }
}

class MonitoringModel {
  String scanner_used;
  String depth_pins;
  dynamic scanner_used_after;
  dynamic profile_bars;
  dynamic completed_signed;

  MonitoringModel.fromJson(Map<String, dynamic> json)
      : scanner_used = json["scanner_used"] ?? "0",
        depth_pins = json["depth_pins"] ?? "0",
        profile_bars = json["profile_bars"] ?? "0",
        scanner_used_after = json["scanner_used_after"] ?? "0",
        completed_signed = json["completed_signed"] ?? "0";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['scanner_used'] = scanner_used;
    map['depth_pins'] = depth_pins;
    map['profile_bars'] = profile_bars;
    map['scanner_used_after'] = scanner_used_after;
    map['completed_signed'] = completed_signed;
    return map;
  }
}

class EquipmentCleaningModel {
  String barriers_signage;
  String lines_cleaned;
  dynamic hopper_cleaned;
  dynamic machine_Cleaned;
  dynamic faults_repairs;
  dynamic delay;
  dynamic delay_date;
  dynamic note;

  EquipmentCleaningModel.fromJson(Map<String, dynamic> json)
      : barriers_signage = json["barriers_signage"] ?? "0",
        lines_cleaned = json["lines_cleaned"] ?? "0",
        hopper_cleaned = json["hopper_cleaned"] ?? "0",
        machine_Cleaned = json["machine_Cleaned"] ?? "0",
        faults_repairs = json["faults_repairs"] ?? "0",
        delay = json["delay"] ?? "",
        delay_date = json["delay_date"] ?? "",
        note = json["note"] ?? "";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['barriers_signage'] = barriers_signage;
    map['lines_cleaned'] = lines_cleaned;
    map['hopper_cleaned'] = hopper_cleaned;
    map['machine_Cleaned'] = machine_Cleaned;
    map['faults_repairs'] = faults_repairs;
    map['delay'] = delay;
    map['delay_date'] = delay_date;
    map['note'] = note;
    return map;
  }
}

class ChemicalAddedModel {
  dynamic plaster_sizer;
  dynamic hca;

  ChemicalAddedModel.fromJson(Map<String, dynamic> json)
      : plaster_sizer = json["plaster_sizer"] ?? "0",
        hca = json["hca"] ?? "0";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['plaster_sizer'] = plaster_sizer;
    map['hca'] = hca;
    return map;
  }
}

class FiberAddedModel {
  dynamic mono;
  dynamic duro;

  FiberAddedModel.fromJson(Map<String, dynamic> json)
      : mono = json["mono"] ?? "0",
        duro = json["duro"] ?? "0";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['mono'] = mono;
    map['duro'] = duro;
    return map;
  }
}
