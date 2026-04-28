    class GetSlotsModel {
      List<GetSlotsResult>? result;
      String? message;
      String? status;

      GetSlotsModel({this.result, this.message, this.status});

      GetSlotsModel.fromJson(Map<String, dynamic> json) {
        if (json['result'] != null) {
          result = <GetSlotsResult>[];
          json['result'].forEach((v) {
            result!.add(new GetSlotsResult.fromJson(v));
          });
        }
        message = json['message'];
        status = json['status'];
      }

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.result != null) {
          data['result'] = this.result!.map((v) => v.toJson()).toList();
        }
        data['message'] = this.message;
        data['status'] = this.status;
        return data;
      }
    }

    class GetSlotsResult {
      String? id;
      String? time;
      String? timeMatched;
      String? availableSlot;
      GetSlotsResult({this.id, this.time, this.timeMatched});

      GetSlotsResult.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        time = json['time'];
        timeMatched = json['time_matched'];
        availableSlot = json['available_slot'];
      }

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['time'] = this.time;
        data['time_matched'] = this.timeMatched;
        data['available_slot'] = this.availableSlot;
        return data;
      }
    }
