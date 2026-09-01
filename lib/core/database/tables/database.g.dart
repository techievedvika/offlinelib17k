// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apaarIdMeta =
      const VerificationMeta('apaarId');
  @override
  late final GeneratedColumn<String> apaarId = GeneratedColumn<String>(
      'apaar_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _penIdMeta = const VerificationMeta('penId');
  @override
  late final GeneratedColumn<String> penId = GeneratedColumn<String>(
      'pen_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uniqueIdMeta =
      const VerificationMeta('uniqueId');
  @override
  late final GeneratedColumn<String> uniqueId = GeneratedColumn<String>(
      'unique_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
      'school', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentClassMeta =
      const VerificationMeta('studentClass');
  @override
  late final GeneratedColumn<String> studentClass = GeneratedColumn<String>(
      'student_class', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rollnoMeta = const VerificationMeta('rollno');
  @override
  late final GeneratedColumn<String> rollno = GeneratedColumn<String>(
      'rollno', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        apaarId,
        penId,
        uniqueId,
        school,
        name,
        studentClass,
        rollno,
        gender,
        status,
        reason,
        createdAt,
        updatedAt,
        createdBy,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(Insertable<Student> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('apaar_id')) {
      context.handle(_apaarIdMeta,
          apaarId.isAcceptableOrUnknown(data['apaar_id']!, _apaarIdMeta));
    }
    if (data.containsKey('pen_id')) {
      context.handle(
          _penIdMeta, penId.isAcceptableOrUnknown(data['pen_id']!, _penIdMeta));
    }
    if (data.containsKey('unique_id')) {
      context.handle(_uniqueIdMeta,
          uniqueId.isAcceptableOrUnknown(data['unique_id']!, _uniqueIdMeta));
    }
    if (data.containsKey('school')) {
      context.handle(_schoolMeta,
          school.isAcceptableOrUnknown(data['school']!, _schoolMeta));
    } else if (isInserting) {
      context.missing(_schoolMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('student_class')) {
      context.handle(
          _studentClassMeta,
          studentClass.isAcceptableOrUnknown(
              data['student_class']!, _studentClassMeta));
    } else if (isInserting) {
      context.missing(_studentClassMeta);
    }
    if (data.containsKey('rollno')) {
      context.handle(_rollnoMeta,
          rollno.isAcceptableOrUnknown(data['rollno']!, _rollnoMeta));
    } else if (isInserting) {
      context.missing(_rollnoMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rollno};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      apaarId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}apaar_id']),
      penId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pen_id']),
      uniqueId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unique_id']),
      school: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}school'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      studentClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_class'])!,
      rollno: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rollno'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final int? id;
  final String uuid;
  final String? apaarId;
  final String? penId;
  final String? uniqueId;
  final String school;
  final String name;
  final String studentClass;
  final String rollno;
  final String gender;
  final String? status;
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final String syncStatus;
  const Student(
      {this.id,
      required this.uuid,
      this.apaarId,
      this.penId,
      this.uniqueId,
      required this.school,
      required this.name,
      required this.studentClass,
      required this.rollno,
      required this.gender,
      this.status,
      this.reason,
      required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || apaarId != null) {
      map['apaar_id'] = Variable<String>(apaarId);
    }
    if (!nullToAbsent || penId != null) {
      map['pen_id'] = Variable<String>(penId);
    }
    if (!nullToAbsent || uniqueId != null) {
      map['unique_id'] = Variable<String>(uniqueId);
    }
    map['school'] = Variable<String>(school);
    map['name'] = Variable<String>(name);
    map['student_class'] = Variable<String>(studentClass);
    map['rollno'] = Variable<String>(rollno);
    map['gender'] = Variable<String>(gender);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_by'] = Variable<int>(createdBy);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      uuid: Value(uuid),
      apaarId: apaarId == null && nullToAbsent
          ? const Value.absent()
          : Value(apaarId),
      penId:
          penId == null && nullToAbsent ? const Value.absent() : Value(penId),
      uniqueId: uniqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(uniqueId),
      school: Value(school),
      name: Value(name),
      studentClass: Value(studentClass),
      rollno: Value(rollno),
      gender: Value(gender),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: Value(createdBy),
      syncStatus: Value(syncStatus),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int?>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      apaarId: serializer.fromJson<String?>(json['apaarId']),
      penId: serializer.fromJson<String?>(json['penId']),
      uniqueId: serializer.fromJson<String?>(json['uniqueId']),
      school: serializer.fromJson<String>(json['school']),
      name: serializer.fromJson<String>(json['name']),
      studentClass: serializer.fromJson<String>(json['studentClass']),
      rollno: serializer.fromJson<String>(json['rollno']),
      gender: serializer.fromJson<String>(json['gender']),
      status: serializer.fromJson<String?>(json['status']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'uuid': serializer.toJson<String>(uuid),
      'apaarId': serializer.toJson<String?>(apaarId),
      'penId': serializer.toJson<String?>(penId),
      'uniqueId': serializer.toJson<String?>(uniqueId),
      'school': serializer.toJson<String>(school),
      'name': serializer.toJson<String>(name),
      'studentClass': serializer.toJson<String>(studentClass),
      'rollno': serializer.toJson<String>(rollno),
      'gender': serializer.toJson<String>(gender),
      'status': serializer.toJson<String?>(status),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdBy': serializer.toJson<int>(createdBy),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Student copyWith(
          {Value<int?> id = const Value.absent(),
          String? uuid,
          Value<String?> apaarId = const Value.absent(),
          Value<String?> penId = const Value.absent(),
          Value<String?> uniqueId = const Value.absent(),
          String? school,
          String? name,
          String? studentClass,
          String? rollno,
          String? gender,
          Value<String?> status = const Value.absent(),
          Value<String?> reason = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          int? createdBy,
          String? syncStatus}) =>
      Student(
        id: id.present ? id.value : this.id,
        uuid: uuid ?? this.uuid,
        apaarId: apaarId.present ? apaarId.value : this.apaarId,
        penId: penId.present ? penId.value : this.penId,
        uniqueId: uniqueId.present ? uniqueId.value : this.uniqueId,
        school: school ?? this.school,
        name: name ?? this.name,
        studentClass: studentClass ?? this.studentClass,
        rollno: rollno ?? this.rollno,
        gender: gender ?? this.gender,
        status: status.present ? status.value : this.status,
        reason: reason.present ? reason.value : this.reason,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      apaarId: data.apaarId.present ? data.apaarId.value : this.apaarId,
      penId: data.penId.present ? data.penId.value : this.penId,
      uniqueId: data.uniqueId.present ? data.uniqueId.value : this.uniqueId,
      school: data.school.present ? data.school.value : this.school,
      name: data.name.present ? data.name.value : this.name,
      studentClass: data.studentClass.present
          ? data.studentClass.value
          : this.studentClass,
      rollno: data.rollno.present ? data.rollno.value : this.rollno,
      gender: data.gender.present ? data.gender.value : this.gender,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('apaarId: $apaarId, ')
          ..write('penId: $penId, ')
          ..write('uniqueId: $uniqueId, ')
          ..write('school: $school, ')
          ..write('name: $name, ')
          ..write('studentClass: $studentClass, ')
          ..write('rollno: $rollno, ')
          ..write('gender: $gender, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      apaarId,
      penId,
      uniqueId,
      school,
      name,
      studentClass,
      rollno,
      gender,
      status,
      reason,
      createdAt,
      updatedAt,
      createdBy,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.apaarId == this.apaarId &&
          other.penId == this.penId &&
          other.uniqueId == this.uniqueId &&
          other.school == this.school &&
          other.name == this.name &&
          other.studentClass == this.studentClass &&
          other.rollno == this.rollno &&
          other.gender == this.gender &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.syncStatus == this.syncStatus);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int?> id;
  final Value<String> uuid;
  final Value<String?> apaarId;
  final Value<String?> penId;
  final Value<String?> uniqueId;
  final Value<String> school;
  final Value<String> name;
  final Value<String> studentClass;
  final Value<String> rollno;
  final Value<String> gender;
  final Value<String?> status;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> createdBy;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.apaarId = const Value.absent(),
    this.penId = const Value.absent(),
    this.uniqueId = const Value.absent(),
    this.school = const Value.absent(),
    this.name = const Value.absent(),
    this.studentClass = const Value.absent(),
    this.rollno = const Value.absent(),
    this.gender = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    this.apaarId = const Value.absent(),
    this.penId = const Value.absent(),
    this.uniqueId = const Value.absent(),
    required String school,
    required String name,
    required String studentClass,
    required String rollno,
    required String gender,
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required int createdBy,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : uuid = Value(uuid),
        school = Value(school),
        name = Value(name),
        studentClass = Value(studentClass),
        rollno = Value(rollno),
        gender = Value(gender),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        createdBy = Value(createdBy);
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? apaarId,
    Expression<String>? penId,
    Expression<String>? uniqueId,
    Expression<String>? school,
    Expression<String>? name,
    Expression<String>? studentClass,
    Expression<String>? rollno,
    Expression<String>? gender,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? createdBy,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (apaarId != null) 'apaar_id': apaarId,
      if (penId != null) 'pen_id': penId,
      if (uniqueId != null) 'unique_id': uniqueId,
      if (school != null) 'school': school,
      if (name != null) 'name': name,
      if (studentClass != null) 'student_class': studentClass,
      if (rollno != null) 'rollno': rollno,
      if (gender != null) 'gender': gender,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith(
      {Value<int?>? id,
      Value<String>? uuid,
      Value<String?>? apaarId,
      Value<String?>? penId,
      Value<String?>? uniqueId,
      Value<String>? school,
      Value<String>? name,
      Value<String>? studentClass,
      Value<String>? rollno,
      Value<String>? gender,
      Value<String?>? status,
      Value<String?>? reason,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? createdBy,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return StudentsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      apaarId: apaarId ?? this.apaarId,
      penId: penId ?? this.penId,
      uniqueId: uniqueId ?? this.uniqueId,
      school: school ?? this.school,
      name: name ?? this.name,
      studentClass: studentClass ?? this.studentClass,
      rollno: rollno ?? this.rollno,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (apaarId.present) {
      map['apaar_id'] = Variable<String>(apaarId.value);
    }
    if (penId.present) {
      map['pen_id'] = Variable<String>(penId.value);
    }
    if (uniqueId.present) {
      map['unique_id'] = Variable<String>(uniqueId.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (studentClass.present) {
      map['student_class'] = Variable<String>(studentClass.value);
    }
    if (rollno.present) {
      map['rollno'] = Variable<String>(rollno.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('apaarId: $apaarId, ')
          ..write('penId: $penId, ')
          ..write('uniqueId: $uniqueId, ')
          ..write('school: $school, ')
          ..write('name: $name, ')
          ..write('studentClass: $studentClass, ')
          ..write('rollno: $rollno, ')
          ..write('gender: $gender, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isbnMeta = const VerificationMeta('isbn');
  @override
  late final GeneratedColumn<String> isbn = GeneratedColumn<String>(
      'isbn', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _publisherMeta =
      const VerificationMeta('publisher');
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
      'publisher', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _generMeta = const VerificationMeta('gener');
  @override
  late final GeneratedColumn<String> gener = GeneratedColumn<String>(
      'gener', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverPageMeta =
      const VerificationMeta('coverPage');
  @override
  late final GeneratedColumn<String> coverPage = GeneratedColumn<String>(
      'cover_page', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        isbn,
        title,
        publisher,
        author,
        language,
        gener,
        level,
        coverPage,
        code,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(Insertable<Book> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('isbn')) {
      context.handle(
          _isbnMeta, isbn.isAcceptableOrUnknown(data['isbn']!, _isbnMeta));
    } else if (isInserting) {
      context.missing(_isbnMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('publisher')) {
      context.handle(_publisherMeta,
          publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('gener')) {
      context.handle(
          _generMeta, gener.isAcceptableOrUnknown(data['gener']!, _generMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('cover_page')) {
      context.handle(_coverPageMeta,
          coverPage.isAcceptableOrUnknown(data['cover_page']!, _coverPageMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {isbn};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      isbn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}isbn'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      publisher: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}publisher']),
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      gener: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gener']),
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level']),
      coverPage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_page']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final int? id;
  final String isbn;
  final String title;
  final String? publisher;
  final String? author;
  final String? language;
  final String? gener;
  final String? level;
  final String? coverPage;
  final String? code;
  final DateTime updatedAt;
  final String syncStatus;
  const Book(
      {this.id,
      required this.isbn,
      required this.title,
      this.publisher,
      this.author,
      this.language,
      this.gener,
      this.level,
      this.coverPage,
      this.code,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['isbn'] = Variable<String>(isbn);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || gener != null) {
      map['gener'] = Variable<String>(gener);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(level);
    }
    if (!nullToAbsent || coverPage != null) {
      map['cover_page'] = Variable<String>(coverPage);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      isbn: Value(isbn),
      title: Value(title),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      gener:
          gener == null && nullToAbsent ? const Value.absent() : Value(gener),
      level:
          level == null && nullToAbsent ? const Value.absent() : Value(level),
      coverPage: coverPage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPage),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Book.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int?>(json['id']),
      isbn: serializer.fromJson<String>(json['isbn']),
      title: serializer.fromJson<String>(json['title']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      author: serializer.fromJson<String?>(json['author']),
      language: serializer.fromJson<String?>(json['language']),
      gener: serializer.fromJson<String?>(json['gener']),
      level: serializer.fromJson<String?>(json['level']),
      coverPage: serializer.fromJson<String?>(json['coverPage']),
      code: serializer.fromJson<String?>(json['code']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'isbn': serializer.toJson<String>(isbn),
      'title': serializer.toJson<String>(title),
      'publisher': serializer.toJson<String?>(publisher),
      'author': serializer.toJson<String?>(author),
      'language': serializer.toJson<String?>(language),
      'gener': serializer.toJson<String?>(gener),
      'level': serializer.toJson<String?>(level),
      'coverPage': serializer.toJson<String?>(coverPage),
      'code': serializer.toJson<String?>(code),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Book copyWith(
          {Value<int?> id = const Value.absent(),
          String? isbn,
          String? title,
          Value<String?> publisher = const Value.absent(),
          Value<String?> author = const Value.absent(),
          Value<String?> language = const Value.absent(),
          Value<String?> gener = const Value.absent(),
          Value<String?> level = const Value.absent(),
          Value<String?> coverPage = const Value.absent(),
          Value<String?> code = const Value.absent(),
          DateTime? updatedAt,
          String? syncStatus}) =>
      Book(
        id: id.present ? id.value : this.id,
        isbn: isbn ?? this.isbn,
        title: title ?? this.title,
        publisher: publisher.present ? publisher.value : this.publisher,
        author: author.present ? author.value : this.author,
        language: language.present ? language.value : this.language,
        gener: gener.present ? gener.value : this.gener,
        level: level.present ? level.value : this.level,
        coverPage: coverPage.present ? coverPage.value : this.coverPage,
        code: code.present ? code.value : this.code,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      isbn: data.isbn.present ? data.isbn.value : this.isbn,
      title: data.title.present ? data.title.value : this.title,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      author: data.author.present ? data.author.value : this.author,
      language: data.language.present ? data.language.value : this.language,
      gener: data.gener.present ? data.gener.value : this.gener,
      level: data.level.present ? data.level.value : this.level,
      coverPage: data.coverPage.present ? data.coverPage.value : this.coverPage,
      code: data.code.present ? data.code.value : this.code,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('isbn: $isbn, ')
          ..write('title: $title, ')
          ..write('publisher: $publisher, ')
          ..write('author: $author, ')
          ..write('language: $language, ')
          ..write('gener: $gener, ')
          ..write('level: $level, ')
          ..write('coverPage: $coverPage, ')
          ..write('code: $code, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isbn, title, publisher, author, language,
      gener, level, coverPage, code, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.isbn == this.isbn &&
          other.title == this.title &&
          other.publisher == this.publisher &&
          other.author == this.author &&
          other.language == this.language &&
          other.gener == this.gener &&
          other.level == this.level &&
          other.coverPage == this.coverPage &&
          other.code == this.code &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int?> id;
  final Value<String> isbn;
  final Value<String> title;
  final Value<String?> publisher;
  final Value<String?> author;
  final Value<String?> language;
  final Value<String?> gener;
  final Value<String?> level;
  final Value<String?> coverPage;
  final Value<String?> code;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.isbn = const Value.absent(),
    this.title = const Value.absent(),
    this.publisher = const Value.absent(),
    this.author = const Value.absent(),
    this.language = const Value.absent(),
    this.gener = const Value.absent(),
    this.level = const Value.absent(),
    this.coverPage = const Value.absent(),
    this.code = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String isbn,
    required String title,
    this.publisher = const Value.absent(),
    this.author = const Value.absent(),
    this.language = const Value.absent(),
    this.gener = const Value.absent(),
    this.level = const Value.absent(),
    this.coverPage = const Value.absent(),
    this.code = const Value.absent(),
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : isbn = Value(isbn),
        title = Value(title),
        updatedAt = Value(updatedAt);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<String>? isbn,
    Expression<String>? title,
    Expression<String>? publisher,
    Expression<String>? author,
    Expression<String>? language,
    Expression<String>? gener,
    Expression<String>? level,
    Expression<String>? coverPage,
    Expression<String>? code,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isbn != null) 'isbn': isbn,
      if (title != null) 'title': title,
      if (publisher != null) 'publisher': publisher,
      if (author != null) 'author': author,
      if (language != null) 'language': language,
      if (gener != null) 'gener': gener,
      if (level != null) 'level': level,
      if (coverPage != null) 'cover_page': coverPage,
      if (code != null) 'code': code,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith(
      {Value<int?>? id,
      Value<String>? isbn,
      Value<String>? title,
      Value<String?>? publisher,
      Value<String?>? author,
      Value<String?>? language,
      Value<String?>? gener,
      Value<String?>? level,
      Value<String?>? coverPage,
      Value<String?>? code,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return BooksCompanion(
      id: id ?? this.id,
      isbn: isbn ?? this.isbn,
      title: title ?? this.title,
      publisher: publisher ?? this.publisher,
      author: author ?? this.author,
      language: language ?? this.language,
      gener: gener ?? this.gener,
      level: level ?? this.level,
      coverPage: coverPage ?? this.coverPage,
      code: code ?? this.code,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isbn.present) {
      map['isbn'] = Variable<String>(isbn.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (gener.present) {
      map['gener'] = Variable<String>(gener.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (coverPage.present) {
      map['cover_page'] = Variable<String>(coverPage.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('isbn: $isbn, ')
          ..write('title: $title, ')
          ..write('publisher: $publisher, ')
          ..write('author: $author, ')
          ..write('language: $language, ')
          ..write('gener: $gener, ')
          ..write('level: $level, ')
          ..write('coverPage: $coverPage, ')
          ..write('code: $code, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookIssuesTable extends BookIssues
    with TableInfo<$BookIssuesTable, BookIssue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookIssuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _uniqidMeta = const VerificationMeta('uniqid');
  @override
  late final GeneratedColumn<String> uniqid = GeneratedColumn<String>(
      'uniqid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIsbnMeta =
      const VerificationMeta('bookIsbn');
  @override
  late final GeneratedColumn<String> bookIsbn = GeneratedColumn<String>(
      'book_isbn', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookNameMeta =
      const VerificationMeta('bookName');
  @override
  late final GeneratedColumn<String> bookName = GeneratedColumn<String>(
      'book_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentRollnoMeta =
      const VerificationMeta('studentRollno');
  @override
  late final GeneratedColumn<String> studentRollno = GeneratedColumn<String>(
      'student_rollno', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _studentGradeMeta =
      const VerificationMeta('studentGrade');
  @override
  late final GeneratedColumn<String> studentGrade = GeneratedColumn<String>(
      'student_grade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _submittedAtMeta =
      const VerificationMeta('submittedAt');
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
      'submitted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _localRowIdMeta =
      const VerificationMeta('localRowId');
  @override
  late final GeneratedColumn<int> localRowId = GeneratedColumn<int>(
      'local_row_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uniqid,
        uuid,
        bookIsbn,
        bookName,
        studentRollno,
        studentGrade,
        status,
        createdAt,
        updatedAt,
        submittedAt,
        createdBy,
        syncStatus,
        localRowId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_issues';
  @override
  VerificationContext validateIntegrity(Insertable<BookIssue> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uniqid')) {
      context.handle(_uniqidMeta,
          uniqid.isAcceptableOrUnknown(data['uniqid']!, _uniqidMeta));
    } else if (isInserting) {
      context.missing(_uniqidMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('book_isbn')) {
      context.handle(_bookIsbnMeta,
          bookIsbn.isAcceptableOrUnknown(data['book_isbn']!, _bookIsbnMeta));
    } else if (isInserting) {
      context.missing(_bookIsbnMeta);
    }
    if (data.containsKey('book_name')) {
      context.handle(_bookNameMeta,
          bookName.isAcceptableOrUnknown(data['book_name']!, _bookNameMeta));
    } else if (isInserting) {
      context.missing(_bookNameMeta);
    }
    if (data.containsKey('student_rollno')) {
      context.handle(
          _studentRollnoMeta,
          studentRollno.isAcceptableOrUnknown(
              data['student_rollno']!, _studentRollnoMeta));
    } else if (isInserting) {
      context.missing(_studentRollnoMeta);
    }
    if (data.containsKey('student_grade')) {
      context.handle(
          _studentGradeMeta,
          studentGrade.isAcceptableOrUnknown(
              data['student_grade']!, _studentGradeMeta));
    } else if (isInserting) {
      context.missing(_studentGradeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
          _submittedAtMeta,
          submittedAt.isAcceptableOrUnknown(
              data['submitted_at']!, _submittedAtMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('local_row_id')) {
      context.handle(
          _localRowIdMeta,
          localRowId.isAcceptableOrUnknown(
              data['local_row_id']!, _localRowIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localRowId};
  @override
  BookIssue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookIssue(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      uniqid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uniqid'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      bookIsbn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_isbn'])!,
      bookName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_name'])!,
      studentRollno: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_rollno'])!,
      studentGrade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}student_grade'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      submittedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}submitted_at']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      localRowId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_row_id'])!,
    );
  }

  @override
  $BookIssuesTable createAlias(String alias) {
    return $BookIssuesTable(attachedDatabase, alias);
  }
}

class BookIssue extends DataClass implements Insertable<BookIssue> {
  final int? id;
  final String uniqid;
  final String uuid;
  final String bookIsbn;
  final String bookName;
  final String studentRollno;
  final String studentGrade;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? submittedAt;
  final int createdBy;
  final String syncStatus;
  final int localRowId;
  const BookIssue(
      {this.id,
      required this.uniqid,
      required this.uuid,
      required this.bookIsbn,
      required this.bookName,
      required this.studentRollno,
      required this.studentGrade,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.submittedAt,
      required this.createdBy,
      required this.syncStatus,
      required this.localRowId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['uniqid'] = Variable<String>(uniqid);
    map['uuid'] = Variable<String>(uuid);
    map['book_isbn'] = Variable<String>(bookIsbn);
    map['book_name'] = Variable<String>(bookName);
    map['student_rollno'] = Variable<String>(studentRollno);
    map['student_grade'] = Variable<String>(studentGrade);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || submittedAt != null) {
      map['submitted_at'] = Variable<DateTime>(submittedAt);
    }
    map['created_by'] = Variable<int>(createdBy);
    map['sync_status'] = Variable<String>(syncStatus);
    map['local_row_id'] = Variable<int>(localRowId);
    return map;
  }

  BookIssuesCompanion toCompanion(bool nullToAbsent) {
    return BookIssuesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      uniqid: Value(uniqid),
      uuid: Value(uuid),
      bookIsbn: Value(bookIsbn),
      bookName: Value(bookName),
      studentRollno: Value(studentRollno),
      studentGrade: Value(studentGrade),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      submittedAt: submittedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedAt),
      createdBy: Value(createdBy),
      syncStatus: Value(syncStatus),
      localRowId: Value(localRowId),
    );
  }

  factory BookIssue.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookIssue(
      id: serializer.fromJson<int?>(json['id']),
      uniqid: serializer.fromJson<String>(json['uniqid']),
      uuid: serializer.fromJson<String>(json['uuid']),
      bookIsbn: serializer.fromJson<String>(json['bookIsbn']),
      bookName: serializer.fromJson<String>(json['bookName']),
      studentRollno: serializer.fromJson<String>(json['studentRollno']),
      studentGrade: serializer.fromJson<String>(json['studentGrade']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      submittedAt: serializer.fromJson<DateTime?>(json['submittedAt']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      localRowId: serializer.fromJson<int>(json['localRowId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'uniqid': serializer.toJson<String>(uniqid),
      'uuid': serializer.toJson<String>(uuid),
      'bookIsbn': serializer.toJson<String>(bookIsbn),
      'bookName': serializer.toJson<String>(bookName),
      'studentRollno': serializer.toJson<String>(studentRollno),
      'studentGrade': serializer.toJson<String>(studentGrade),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'submittedAt': serializer.toJson<DateTime?>(submittedAt),
      'createdBy': serializer.toJson<int>(createdBy),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'localRowId': serializer.toJson<int>(localRowId),
    };
  }

  BookIssue copyWith(
          {Value<int?> id = const Value.absent(),
          String? uniqid,
          String? uuid,
          String? bookIsbn,
          String? bookName,
          String? studentRollno,
          String? studentGrade,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> submittedAt = const Value.absent(),
          int? createdBy,
          String? syncStatus,
          int? localRowId}) =>
      BookIssue(
        id: id.present ? id.value : this.id,
        uniqid: uniqid ?? this.uniqid,
        uuid: uuid ?? this.uuid,
        bookIsbn: bookIsbn ?? this.bookIsbn,
        bookName: bookName ?? this.bookName,
        studentRollno: studentRollno ?? this.studentRollno,
        studentGrade: studentGrade ?? this.studentGrade,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        submittedAt: submittedAt.present ? submittedAt.value : this.submittedAt,
        createdBy: createdBy ?? this.createdBy,
        syncStatus: syncStatus ?? this.syncStatus,
        localRowId: localRowId ?? this.localRowId,
      );
  BookIssue copyWithCompanion(BookIssuesCompanion data) {
    return BookIssue(
      id: data.id.present ? data.id.value : this.id,
      uniqid: data.uniqid.present ? data.uniqid.value : this.uniqid,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      bookIsbn: data.bookIsbn.present ? data.bookIsbn.value : this.bookIsbn,
      bookName: data.bookName.present ? data.bookName.value : this.bookName,
      studentRollno: data.studentRollno.present
          ? data.studentRollno.value
          : this.studentRollno,
      studentGrade: data.studentGrade.present
          ? data.studentGrade.value
          : this.studentGrade,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      submittedAt:
          data.submittedAt.present ? data.submittedAt.value : this.submittedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      localRowId:
          data.localRowId.present ? data.localRowId.value : this.localRowId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookIssue(')
          ..write('id: $id, ')
          ..write('uniqid: $uniqid, ')
          ..write('uuid: $uuid, ')
          ..write('bookIsbn: $bookIsbn, ')
          ..write('bookName: $bookName, ')
          ..write('studentRollno: $studentRollno, ')
          ..write('studentGrade: $studentGrade, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('localRowId: $localRowId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uniqid,
      uuid,
      bookIsbn,
      bookName,
      studentRollno,
      studentGrade,
      status,
      createdAt,
      updatedAt,
      submittedAt,
      createdBy,
      syncStatus,
      localRowId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookIssue &&
          other.id == this.id &&
          other.uniqid == this.uniqid &&
          other.uuid == this.uuid &&
          other.bookIsbn == this.bookIsbn &&
          other.bookName == this.bookName &&
          other.studentRollno == this.studentRollno &&
          other.studentGrade == this.studentGrade &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.submittedAt == this.submittedAt &&
          other.createdBy == this.createdBy &&
          other.syncStatus == this.syncStatus &&
          other.localRowId == this.localRowId);
}

class BookIssuesCompanion extends UpdateCompanion<BookIssue> {
  final Value<int?> id;
  final Value<String> uniqid;
  final Value<String> uuid;
  final Value<String> bookIsbn;
  final Value<String> bookName;
  final Value<String> studentRollno;
  final Value<String> studentGrade;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> submittedAt;
  final Value<int> createdBy;
  final Value<String> syncStatus;
  final Value<int> localRowId;
  const BookIssuesCompanion({
    this.id = const Value.absent(),
    this.uniqid = const Value.absent(),
    this.uuid = const Value.absent(),
    this.bookIsbn = const Value.absent(),
    this.bookName = const Value.absent(),
    this.studentRollno = const Value.absent(),
    this.studentGrade = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.localRowId = const Value.absent(),
  });
  BookIssuesCompanion.insert({
    this.id = const Value.absent(),
    required String uniqid,
    required String uuid,
    required String bookIsbn,
    required String bookName,
    required String studentRollno,
    required String studentGrade,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.submittedAt = const Value.absent(),
    required int createdBy,
    this.syncStatus = const Value.absent(),
    this.localRowId = const Value.absent(),
  })  : uniqid = Value(uniqid),
        uuid = Value(uuid),
        bookIsbn = Value(bookIsbn),
        bookName = Value(bookName),
        studentRollno = Value(studentRollno),
        studentGrade = Value(studentGrade),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        createdBy = Value(createdBy);
  static Insertable<BookIssue> custom({
    Expression<int>? id,
    Expression<String>? uniqid,
    Expression<String>? uuid,
    Expression<String>? bookIsbn,
    Expression<String>? bookName,
    Expression<String>? studentRollno,
    Expression<String>? studentGrade,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? submittedAt,
    Expression<int>? createdBy,
    Expression<String>? syncStatus,
    Expression<int>? localRowId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uniqid != null) 'uniqid': uniqid,
      if (uuid != null) 'uuid': uuid,
      if (bookIsbn != null) 'book_isbn': bookIsbn,
      if (bookName != null) 'book_name': bookName,
      if (studentRollno != null) 'student_rollno': studentRollno,
      if (studentGrade != null) 'student_grade': studentGrade,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (localRowId != null) 'local_row_id': localRowId,
    });
  }

  BookIssuesCompanion copyWith(
      {Value<int?>? id,
      Value<String>? uniqid,
      Value<String>? uuid,
      Value<String>? bookIsbn,
      Value<String>? bookName,
      Value<String>? studentRollno,
      Value<String>? studentGrade,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? submittedAt,
      Value<int>? createdBy,
      Value<String>? syncStatus,
      Value<int>? localRowId}) {
    return BookIssuesCompanion(
      id: id ?? this.id,
      uniqid: uniqid ?? this.uniqid,
      uuid: uuid ?? this.uuid,
      bookIsbn: bookIsbn ?? this.bookIsbn,
      bookName: bookName ?? this.bookName,
      studentRollno: studentRollno ?? this.studentRollno,
      studentGrade: studentGrade ?? this.studentGrade,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      submittedAt: submittedAt ?? this.submittedAt,
      createdBy: createdBy ?? this.createdBy,
      syncStatus: syncStatus ?? this.syncStatus,
      localRowId: localRowId ?? this.localRowId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uniqid.present) {
      map['uniqid'] = Variable<String>(uniqid.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (bookIsbn.present) {
      map['book_isbn'] = Variable<String>(bookIsbn.value);
    }
    if (bookName.present) {
      map['book_name'] = Variable<String>(bookName.value);
    }
    if (studentRollno.present) {
      map['student_rollno'] = Variable<String>(studentRollno.value);
    }
    if (studentGrade.present) {
      map['student_grade'] = Variable<String>(studentGrade.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (localRowId.present) {
      map['local_row_id'] = Variable<int>(localRowId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookIssuesCompanion(')
          ..write('id: $id, ')
          ..write('uniqid: $uniqid, ')
          ..write('uuid: $uuid, ')
          ..write('bookIsbn: $bookIsbn, ')
          ..write('bookName: $bookName, ')
          ..write('studentRollno: $studentRollno, ')
          ..write('studentGrade: $studentGrade, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('localRowId: $localRowId')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _activityNameMeta =
      const VerificationMeta('activityName');
  @override
  late final GeneratedColumn<String> activityName = GeneratedColumn<String>(
      'activity_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activityDescriptionMeta =
      const VerificationMeta('activityDescription');
  @override
  late final GeneratedColumn<String> activityDescription =
      GeneratedColumn<String>('activity_description', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
      'photo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bookDetailsMeta =
      const VerificationMeta('bookDetails');
  @override
  late final GeneratedColumn<String> bookDetails = GeneratedColumn<String>(
      'book_details', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _participantsGradesMeta =
      const VerificationMeta('participantsGrades');
  @override
  late final GeneratedColumn<String> participantsGrades =
      GeneratedColumn<String>('participants_grades', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _participantsNumberMeta =
      const VerificationMeta('participantsNumber');
  @override
  late final GeneratedColumn<int> participantsNumber = GeneratedColumn<int>(
      'participants_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conductedByMeta =
      const VerificationMeta('conductedBy');
  @override
  late final GeneratedColumn<String> conductedBy = GeneratedColumn<String>(
      'conducted_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
      'school', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
      'created_by', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        localId,
        date,
        activityName,
        activityDescription,
        photo,
        bookDetails,
        participantsGrades,
        participantsNumber,
        conductedBy,
        school,
        createdBy,
        createdAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ActivityLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('activity_name')) {
      context.handle(
          _activityNameMeta,
          activityName.isAcceptableOrUnknown(
              data['activity_name']!, _activityNameMeta));
    } else if (isInserting) {
      context.missing(_activityNameMeta);
    }
    if (data.containsKey('activity_description')) {
      context.handle(
          _activityDescriptionMeta,
          activityDescription.isAcceptableOrUnknown(
              data['activity_description']!, _activityDescriptionMeta));
    } else if (isInserting) {
      context.missing(_activityDescriptionMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    }
    if (data.containsKey('book_details')) {
      context.handle(
          _bookDetailsMeta,
          bookDetails.isAcceptableOrUnknown(
              data['book_details']!, _bookDetailsMeta));
    } else if (isInserting) {
      context.missing(_bookDetailsMeta);
    }
    if (data.containsKey('participants_grades')) {
      context.handle(
          _participantsGradesMeta,
          participantsGrades.isAcceptableOrUnknown(
              data['participants_grades']!, _participantsGradesMeta));
    } else if (isInserting) {
      context.missing(_participantsGradesMeta);
    }
    if (data.containsKey('participants_number')) {
      context.handle(
          _participantsNumberMeta,
          participantsNumber.isAcceptableOrUnknown(
              data['participants_number']!, _participantsNumberMeta));
    } else if (isInserting) {
      context.missing(_participantsNumberMeta);
    }
    if (data.containsKey('conducted_by')) {
      context.handle(
          _conductedByMeta,
          conductedBy.isAcceptableOrUnknown(
              data['conducted_by']!, _conductedByMeta));
    } else if (isInserting) {
      context.missing(_conductedByMeta);
    }
    if (data.containsKey('school')) {
      context.handle(_schoolMeta,
          school.isAcceptableOrUnknown(data['school']!, _schoolMeta));
    } else if (isInserting) {
      context.missing(_schoolMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  ActivityLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      activityName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity_name'])!,
      activityDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}activity_description'])!,
      photo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo']),
      bookDetails: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_details'])!,
      participantsGrades: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}participants_grades'])!,
      participantsNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}participants_number'])!,
      conductedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conducted_by'])!,
      school: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}school'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }
}

class ActivityLog extends DataClass implements Insertable<ActivityLog> {
  final int? id;
  final String localId;
  final DateTime date;
  final String activityName;
  final String activityDescription;
  final String? photo;
  final String bookDetails;
  final String participantsGrades;
  final int participantsNumber;
  final String conductedBy;
  final String school;
  final int createdBy;
  final DateTime createdAt;
  final String syncStatus;
  const ActivityLog(
      {this.id,
      required this.localId,
      required this.date,
      required this.activityName,
      required this.activityDescription,
      this.photo,
      required this.bookDetails,
      required this.participantsGrades,
      required this.participantsNumber,
      required this.conductedBy,
      required this.school,
      required this.createdBy,
      required this.createdAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['local_id'] = Variable<String>(localId);
    map['date'] = Variable<DateTime>(date);
    map['activity_name'] = Variable<String>(activityName);
    map['activity_description'] = Variable<String>(activityDescription);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    map['book_details'] = Variable<String>(bookDetails);
    map['participants_grades'] = Variable<String>(participantsGrades);
    map['participants_number'] = Variable<int>(participantsNumber);
    map['conducted_by'] = Variable<String>(conductedBy);
    map['school'] = Variable<String>(school);
    map['created_by'] = Variable<int>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      localId: Value(localId),
      date: Value(date),
      activityName: Value(activityName),
      activityDescription: Value(activityDescription),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
      bookDetails: Value(bookDetails),
      participantsGrades: Value(participantsGrades),
      participantsNumber: Value(participantsNumber),
      conductedBy: Value(conductedBy),
      school: Value(school),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLog(
      id: serializer.fromJson<int?>(json['id']),
      localId: serializer.fromJson<String>(json['localId']),
      date: serializer.fromJson<DateTime>(json['date']),
      activityName: serializer.fromJson<String>(json['activityName']),
      activityDescription:
          serializer.fromJson<String>(json['activityDescription']),
      photo: serializer.fromJson<String?>(json['photo']),
      bookDetails: serializer.fromJson<String>(json['bookDetails']),
      participantsGrades:
          serializer.fromJson<String>(json['participantsGrades']),
      participantsNumber: serializer.fromJson<int>(json['participantsNumber']),
      conductedBy: serializer.fromJson<String>(json['conductedBy']),
      school: serializer.fromJson<String>(json['school']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'localId': serializer.toJson<String>(localId),
      'date': serializer.toJson<DateTime>(date),
      'activityName': serializer.toJson<String>(activityName),
      'activityDescription': serializer.toJson<String>(activityDescription),
      'photo': serializer.toJson<String?>(photo),
      'bookDetails': serializer.toJson<String>(bookDetails),
      'participantsGrades': serializer.toJson<String>(participantsGrades),
      'participantsNumber': serializer.toJson<int>(participantsNumber),
      'conductedBy': serializer.toJson<String>(conductedBy),
      'school': serializer.toJson<String>(school),
      'createdBy': serializer.toJson<int>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  ActivityLog copyWith(
          {Value<int?> id = const Value.absent(),
          String? localId,
          DateTime? date,
          String? activityName,
          String? activityDescription,
          Value<String?> photo = const Value.absent(),
          String? bookDetails,
          String? participantsGrades,
          int? participantsNumber,
          String? conductedBy,
          String? school,
          int? createdBy,
          DateTime? createdAt,
          String? syncStatus}) =>
      ActivityLog(
        id: id.present ? id.value : this.id,
        localId: localId ?? this.localId,
        date: date ?? this.date,
        activityName: activityName ?? this.activityName,
        activityDescription: activityDescription ?? this.activityDescription,
        photo: photo.present ? photo.value : this.photo,
        bookDetails: bookDetails ?? this.bookDetails,
        participantsGrades: participantsGrades ?? this.participantsGrades,
        participantsNumber: participantsNumber ?? this.participantsNumber,
        conductedBy: conductedBy ?? this.conductedBy,
        school: school ?? this.school,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  ActivityLog copyWithCompanion(ActivityLogsCompanion data) {
    return ActivityLog(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      date: data.date.present ? data.date.value : this.date,
      activityName: data.activityName.present
          ? data.activityName.value
          : this.activityName,
      activityDescription: data.activityDescription.present
          ? data.activityDescription.value
          : this.activityDescription,
      photo: data.photo.present ? data.photo.value : this.photo,
      bookDetails:
          data.bookDetails.present ? data.bookDetails.value : this.bookDetails,
      participantsGrades: data.participantsGrades.present
          ? data.participantsGrades.value
          : this.participantsGrades,
      participantsNumber: data.participantsNumber.present
          ? data.participantsNumber.value
          : this.participantsNumber,
      conductedBy:
          data.conductedBy.present ? data.conductedBy.value : this.conductedBy,
      school: data.school.present ? data.school.value : this.school,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLog(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('date: $date, ')
          ..write('activityName: $activityName, ')
          ..write('activityDescription: $activityDescription, ')
          ..write('photo: $photo, ')
          ..write('bookDetails: $bookDetails, ')
          ..write('participantsGrades: $participantsGrades, ')
          ..write('participantsNumber: $participantsNumber, ')
          ..write('conductedBy: $conductedBy, ')
          ..write('school: $school, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      localId,
      date,
      activityName,
      activityDescription,
      photo,
      bookDetails,
      participantsGrades,
      participantsNumber,
      conductedBy,
      school,
      createdBy,
      createdAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLog &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.date == this.date &&
          other.activityName == this.activityName &&
          other.activityDescription == this.activityDescription &&
          other.photo == this.photo &&
          other.bookDetails == this.bookDetails &&
          other.participantsGrades == this.participantsGrades &&
          other.participantsNumber == this.participantsNumber &&
          other.conductedBy == this.conductedBy &&
          other.school == this.school &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityLog> {
  final Value<int?> id;
  final Value<String> localId;
  final Value<DateTime> date;
  final Value<String> activityName;
  final Value<String> activityDescription;
  final Value<String?> photo;
  final Value<String> bookDetails;
  final Value<String> participantsGrades;
  final Value<int> participantsNumber;
  final Value<String> conductedBy;
  final Value<String> school;
  final Value<int> createdBy;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.date = const Value.absent(),
    this.activityName = const Value.absent(),
    this.activityDescription = const Value.absent(),
    this.photo = const Value.absent(),
    this.bookDetails = const Value.absent(),
    this.participantsGrades = const Value.absent(),
    this.participantsNumber = const Value.absent(),
    this.conductedBy = const Value.absent(),
    this.school = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    required DateTime date,
    required String activityName,
    required String activityDescription,
    this.photo = const Value.absent(),
    required String bookDetails,
    required String participantsGrades,
    required int participantsNumber,
    required String conductedBy,
    required String school,
    required int createdBy,
    required DateTime createdAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : localId = Value(localId),
        date = Value(date),
        activityName = Value(activityName),
        activityDescription = Value(activityDescription),
        bookDetails = Value(bookDetails),
        participantsGrades = Value(participantsGrades),
        participantsNumber = Value(participantsNumber),
        conductedBy = Value(conductedBy),
        school = Value(school),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt);
  static Insertable<ActivityLog> custom({
    Expression<int>? id,
    Expression<String>? localId,
    Expression<DateTime>? date,
    Expression<String>? activityName,
    Expression<String>? activityDescription,
    Expression<String>? photo,
    Expression<String>? bookDetails,
    Expression<String>? participantsGrades,
    Expression<int>? participantsNumber,
    Expression<String>? conductedBy,
    Expression<String>? school,
    Expression<int>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (date != null) 'date': date,
      if (activityName != null) 'activity_name': activityName,
      if (activityDescription != null)
        'activity_description': activityDescription,
      if (photo != null) 'photo': photo,
      if (bookDetails != null) 'book_details': bookDetails,
      if (participantsGrades != null) 'participants_grades': participantsGrades,
      if (participantsNumber != null) 'participants_number': participantsNumber,
      if (conductedBy != null) 'conducted_by': conductedBy,
      if (school != null) 'school': school,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogsCompanion copyWith(
      {Value<int?>? id,
      Value<String>? localId,
      Value<DateTime>? date,
      Value<String>? activityName,
      Value<String>? activityDescription,
      Value<String?>? photo,
      Value<String>? bookDetails,
      Value<String>? participantsGrades,
      Value<int>? participantsNumber,
      Value<String>? conductedBy,
      Value<String>? school,
      Value<int>? createdBy,
      Value<DateTime>? createdAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      date: date ?? this.date,
      activityName: activityName ?? this.activityName,
      activityDescription: activityDescription ?? this.activityDescription,
      photo: photo ?? this.photo,
      bookDetails: bookDetails ?? this.bookDetails,
      participantsGrades: participantsGrades ?? this.participantsGrades,
      participantsNumber: participantsNumber ?? this.participantsNumber,
      conductedBy: conductedBy ?? this.conductedBy,
      school: school ?? this.school,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (activityName.present) {
      map['activity_name'] = Variable<String>(activityName.value);
    }
    if (activityDescription.present) {
      map['activity_description'] = Variable<String>(activityDescription.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (bookDetails.present) {
      map['book_details'] = Variable<String>(bookDetails.value);
    }
    if (participantsGrades.present) {
      map['participants_grades'] = Variable<String>(participantsGrades.value);
    }
    if (participantsNumber.present) {
      map['participants_number'] = Variable<int>(participantsNumber.value);
    }
    if (conductedBy.present) {
      map['conducted_by'] = Variable<String>(conductedBy.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('date: $date, ')
          ..write('activityName: $activityName, ')
          ..write('activityDescription: $activityDescription, ')
          ..write('photo: $photo, ')
          ..write('bookDetails: $bookDetails, ')
          ..write('participantsGrades: $participantsGrades, ')
          ..write('participantsNumber: $participantsNumber, ')
          ..write('conductedBy: $conductedBy, ')
          ..write('school: $school, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GradesTable extends Grades with TableInfo<$GradesTable, Grade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
      'grade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [grade];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grades';
  @override
  VerificationContext validateIntegrity(Insertable<Grade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {grade};
  @override
  Grade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Grade(
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grade'])!,
    );
  }

  @override
  $GradesTable createAlias(String alias) {
    return $GradesTable(attachedDatabase, alias);
  }
}

class Grade extends DataClass implements Insertable<Grade> {
  final String grade;
  const Grade({required this.grade});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['grade'] = Variable<String>(grade);
    return map;
  }

  GradesCompanion toCompanion(bool nullToAbsent) {
    return GradesCompanion(
      grade: Value(grade),
    );
  }

  factory Grade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Grade(
      grade: serializer.fromJson<String>(json['grade']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'grade': serializer.toJson<String>(grade),
    };
  }

  Grade copyWith({String? grade}) => Grade(
        grade: grade ?? this.grade,
      );
  Grade copyWithCompanion(GradesCompanion data) {
    return Grade(
      grade: data.grade.present ? data.grade.value : this.grade,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Grade(')
          ..write('grade: $grade')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => grade.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Grade && other.grade == this.grade);
}

class GradesCompanion extends UpdateCompanion<Grade> {
  final Value<String> grade;
  final Value<int> rowid;
  const GradesCompanion({
    this.grade = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GradesCompanion.insert({
    required String grade,
    this.rowid = const Value.absent(),
  }) : grade = Value(grade);
  static Insertable<Grade> custom({
    Expression<String>? grade,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (grade != null) 'grade': grade,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GradesCompanion copyWith({Value<String>? grade, Value<int>? rowid}) {
    return GradesCompanion(
      grade: grade ?? this.grade,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GradesCompanion(')
          ..write('grade: $grade, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchoolBasicCacheTable extends SchoolBasicCache
    with TableInfo<$SchoolBasicCacheTable, SchoolBasicCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolBasicCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _schoolPidMeta =
      const VerificationMeta('schoolPid');
  @override
  late final GeneratedColumn<String> schoolPid = GeneratedColumn<String>(
      'school_pid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _distNameMeta =
      const VerificationMeta('distName');
  @override
  late final GeneratedColumn<String> distName = GeneratedColumn<String>(
      'dist_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _schoolCodeNewMeta =
      const VerificationMeta('schoolCodeNew');
  @override
  late final GeneratedColumn<String> schoolCodeNew = GeneratedColumn<String>(
      'school_code_new', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _schoolNameMeta =
      const VerificationMeta('schoolName');
  @override
  late final GeneratedColumn<String> schoolName = GeneratedColumn<String>(
      'school_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _blockNameMeta =
      const VerificationMeta('blockName');
  @override
  late final GeneratedColumn<String> blockName = GeneratedColumn<String>(
      'block_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [schoolPid, state, distName, schoolCodeNew, schoolName, blockName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'school_basic_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<SchoolBasicCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('school_pid')) {
      context.handle(_schoolPidMeta,
          schoolPid.isAcceptableOrUnknown(data['school_pid']!, _schoolPidMeta));
    } else if (isInserting) {
      context.missing(_schoolPidMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('dist_name')) {
      context.handle(_distNameMeta,
          distName.isAcceptableOrUnknown(data['dist_name']!, _distNameMeta));
    } else if (isInserting) {
      context.missing(_distNameMeta);
    }
    if (data.containsKey('school_code_new')) {
      context.handle(
          _schoolCodeNewMeta,
          schoolCodeNew.isAcceptableOrUnknown(
              data['school_code_new']!, _schoolCodeNewMeta));
    } else if (isInserting) {
      context.missing(_schoolCodeNewMeta);
    }
    if (data.containsKey('school_name')) {
      context.handle(
          _schoolNameMeta,
          schoolName.isAcceptableOrUnknown(
              data['school_name']!, _schoolNameMeta));
    } else if (isInserting) {
      context.missing(_schoolNameMeta);
    }
    if (data.containsKey('block_name')) {
      context.handle(_blockNameMeta,
          blockName.isAcceptableOrUnknown(data['block_name']!, _blockNameMeta));
    } else if (isInserting) {
      context.missing(_blockNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {schoolPid};
  @override
  SchoolBasicCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolBasicCacheData(
      schoolPid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}school_pid'])!,
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      distName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dist_name'])!,
      schoolCodeNew: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}school_code_new'])!,
      schoolName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}school_name'])!,
      blockName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}block_name'])!,
    );
  }

  @override
  $SchoolBasicCacheTable createAlias(String alias) {
    return $SchoolBasicCacheTable(attachedDatabase, alias);
  }
}

class SchoolBasicCacheData extends DataClass
    implements Insertable<SchoolBasicCacheData> {
  final String schoolPid;
  final String state;
  final String distName;
  final String schoolCodeNew;
  final String schoolName;
  final String blockName;
  const SchoolBasicCacheData(
      {required this.schoolPid,
      required this.state,
      required this.distName,
      required this.schoolCodeNew,
      required this.schoolName,
      required this.blockName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['school_pid'] = Variable<String>(schoolPid);
    map['state'] = Variable<String>(state);
    map['dist_name'] = Variable<String>(distName);
    map['school_code_new'] = Variable<String>(schoolCodeNew);
    map['school_name'] = Variable<String>(schoolName);
    map['block_name'] = Variable<String>(blockName);
    return map;
  }

  SchoolBasicCacheCompanion toCompanion(bool nullToAbsent) {
    return SchoolBasicCacheCompanion(
      schoolPid: Value(schoolPid),
      state: Value(state),
      distName: Value(distName),
      schoolCodeNew: Value(schoolCodeNew),
      schoolName: Value(schoolName),
      blockName: Value(blockName),
    );
  }

  factory SchoolBasicCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolBasicCacheData(
      schoolPid: serializer.fromJson<String>(json['schoolPid']),
      state: serializer.fromJson<String>(json['state']),
      distName: serializer.fromJson<String>(json['distName']),
      schoolCodeNew: serializer.fromJson<String>(json['schoolCodeNew']),
      schoolName: serializer.fromJson<String>(json['schoolName']),
      blockName: serializer.fromJson<String>(json['blockName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'schoolPid': serializer.toJson<String>(schoolPid),
      'state': serializer.toJson<String>(state),
      'distName': serializer.toJson<String>(distName),
      'schoolCodeNew': serializer.toJson<String>(schoolCodeNew),
      'schoolName': serializer.toJson<String>(schoolName),
      'blockName': serializer.toJson<String>(blockName),
    };
  }

  SchoolBasicCacheData copyWith(
          {String? schoolPid,
          String? state,
          String? distName,
          String? schoolCodeNew,
          String? schoolName,
          String? blockName}) =>
      SchoolBasicCacheData(
        schoolPid: schoolPid ?? this.schoolPid,
        state: state ?? this.state,
        distName: distName ?? this.distName,
        schoolCodeNew: schoolCodeNew ?? this.schoolCodeNew,
        schoolName: schoolName ?? this.schoolName,
        blockName: blockName ?? this.blockName,
      );
  SchoolBasicCacheData copyWithCompanion(SchoolBasicCacheCompanion data) {
    return SchoolBasicCacheData(
      schoolPid: data.schoolPid.present ? data.schoolPid.value : this.schoolPid,
      state: data.state.present ? data.state.value : this.state,
      distName: data.distName.present ? data.distName.value : this.distName,
      schoolCodeNew: data.schoolCodeNew.present
          ? data.schoolCodeNew.value
          : this.schoolCodeNew,
      schoolName:
          data.schoolName.present ? data.schoolName.value : this.schoolName,
      blockName: data.blockName.present ? data.blockName.value : this.blockName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolBasicCacheData(')
          ..write('schoolPid: $schoolPid, ')
          ..write('state: $state, ')
          ..write('distName: $distName, ')
          ..write('schoolCodeNew: $schoolCodeNew, ')
          ..write('schoolName: $schoolName, ')
          ..write('blockName: $blockName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      schoolPid, state, distName, schoolCodeNew, schoolName, blockName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolBasicCacheData &&
          other.schoolPid == this.schoolPid &&
          other.state == this.state &&
          other.distName == this.distName &&
          other.schoolCodeNew == this.schoolCodeNew &&
          other.schoolName == this.schoolName &&
          other.blockName == this.blockName);
}

class SchoolBasicCacheCompanion extends UpdateCompanion<SchoolBasicCacheData> {
  final Value<String> schoolPid;
  final Value<String> state;
  final Value<String> distName;
  final Value<String> schoolCodeNew;
  final Value<String> schoolName;
  final Value<String> blockName;
  final Value<int> rowid;
  const SchoolBasicCacheCompanion({
    this.schoolPid = const Value.absent(),
    this.state = const Value.absent(),
    this.distName = const Value.absent(),
    this.schoolCodeNew = const Value.absent(),
    this.schoolName = const Value.absent(),
    this.blockName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchoolBasicCacheCompanion.insert({
    required String schoolPid,
    required String state,
    required String distName,
    required String schoolCodeNew,
    required String schoolName,
    required String blockName,
    this.rowid = const Value.absent(),
  })  : schoolPid = Value(schoolPid),
        state = Value(state),
        distName = Value(distName),
        schoolCodeNew = Value(schoolCodeNew),
        schoolName = Value(schoolName),
        blockName = Value(blockName);
  static Insertable<SchoolBasicCacheData> custom({
    Expression<String>? schoolPid,
    Expression<String>? state,
    Expression<String>? distName,
    Expression<String>? schoolCodeNew,
    Expression<String>? schoolName,
    Expression<String>? blockName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (schoolPid != null) 'school_pid': schoolPid,
      if (state != null) 'state': state,
      if (distName != null) 'dist_name': distName,
      if (schoolCodeNew != null) 'school_code_new': schoolCodeNew,
      if (schoolName != null) 'school_name': schoolName,
      if (blockName != null) 'block_name': blockName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchoolBasicCacheCompanion copyWith(
      {Value<String>? schoolPid,
      Value<String>? state,
      Value<String>? distName,
      Value<String>? schoolCodeNew,
      Value<String>? schoolName,
      Value<String>? blockName,
      Value<int>? rowid}) {
    return SchoolBasicCacheCompanion(
      schoolPid: schoolPid ?? this.schoolPid,
      state: state ?? this.state,
      distName: distName ?? this.distName,
      schoolCodeNew: schoolCodeNew ?? this.schoolCodeNew,
      schoolName: schoolName ?? this.schoolName,
      blockName: blockName ?? this.blockName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (schoolPid.present) {
      map['school_pid'] = Variable<String>(schoolPid.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (distName.present) {
      map['dist_name'] = Variable<String>(distName.value);
    }
    if (schoolCodeNew.present) {
      map['school_code_new'] = Variable<String>(schoolCodeNew.value);
    }
    if (schoolName.present) {
      map['school_name'] = Variable<String>(schoolName.value);
    }
    if (blockName.present) {
      map['block_name'] = Variable<String>(blockName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolBasicCacheCompanion(')
          ..write('schoolPid: $schoolPid, ')
          ..write('state: $state, ')
          ..write('distName: $distName, ')
          ..write('schoolCodeNew: $schoolCodeNew, ')
          ..write('schoolName: $schoolName, ')
          ..write('blockName: $blockName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeneralLinksCacheTable extends GeneralLinksCache
    with TableInfo<$GeneralLinksCacheTable, GeneralLinksCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneralLinksCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'general_links_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<GeneralLinksCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  GeneralLinksCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneralLinksCacheData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $GeneralLinksCacheTable createAlias(String alias) {
    return $GeneralLinksCacheTable(attachedDatabase, alias);
  }
}

class GeneralLinksCacheData extends DataClass
    implements Insertable<GeneralLinksCacheData> {
  final String key;
  final String value;
  const GeneralLinksCacheData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  GeneralLinksCacheCompanion toCompanion(bool nullToAbsent) {
    return GeneralLinksCacheCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory GeneralLinksCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneralLinksCacheData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  GeneralLinksCacheData copyWith({String? key, String? value}) =>
      GeneralLinksCacheData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  GeneralLinksCacheData copyWithCompanion(GeneralLinksCacheCompanion data) {
    return GeneralLinksCacheData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneralLinksCacheData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneralLinksCacheData &&
          other.key == this.key &&
          other.value == this.value);
}

class GeneralLinksCacheCompanion
    extends UpdateCompanion<GeneralLinksCacheData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const GeneralLinksCacheCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeneralLinksCacheCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<GeneralLinksCacheData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeneralLinksCacheCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return GeneralLinksCacheCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneralLinksCacheCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityKeyMeta =
      const VerificationMeta('entityKey');
  @override
  late final GeneratedColumn<String> entityKey = GeneratedColumn<String>(
      'entity_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityKey,
        operation,
        payloadJson,
        createdAt,
        retryCount,
        lastError
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOutboxData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_key')) {
      context.handle(_entityKeyMeta,
          entityKey.isAcceptableOrUnknown(data['entity_key']!, _entityKeyMeta));
    } else if (isInserting) {
      context.missing(_entityKeyMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_key'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final int id;
  final String entityType;
  final String entityKey;
  final String operation;
  final String payloadJson;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  const SyncOutboxData(
      {required this.id,
      required this.entityType,
      required this.entityKey,
      required this.operation,
      required this.payloadJson,
      required this.createdAt,
      required this.retryCount,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_key'] = Variable<String>(entityKey);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityKey: Value(entityKey),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory SyncOutboxData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityKey: serializer.fromJson<String>(json['entityKey']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityKey': serializer.toJson<String>(entityKey),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  SyncOutboxData copyWith(
          {int? id,
          String? entityType,
          String? entityKey,
          String? operation,
          String? payloadJson,
          DateTime? createdAt,
          int? retryCount,
          Value<String?> lastError = const Value.absent()}) =>
      SyncOutboxData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityKey: entityKey ?? this.entityKey,
        operation: operation ?? this.operation,
        payloadJson: payloadJson ?? this.payloadJson,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityKey: data.entityKey.present ? data.entityKey.value : this.entityKey,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityKey: $entityKey, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityKey, operation,
      payloadJson, createdAt, retryCount, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityKey == this.entityKey &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityKey;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityKey = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityKey,
    required String operation,
    required String payloadJson,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  })  : entityType = Value(entityType),
        entityKey = Value(entityKey),
        operation = Value(operation),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt);
  static Insertable<SyncOutboxData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityKey,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityKey != null) 'entity_key': entityKey,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
    });
  }

  SyncOutboxCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<String>? entityKey,
      Value<String>? operation,
      Value<String>? payloadJson,
      Value<DateTime>? createdAt,
      Value<int>? retryCount,
      Value<String?>? lastError}) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityKey: entityKey ?? this.entityKey,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityKey.present) {
      map['entity_key'] = Variable<String>(entityKey.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityKey: $entityKey, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $PendingUploadsTable extends PendingUploads
    with TableInfo<$PendingUploadsTable, PendingUpload> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingUploadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityKeyMeta =
      const VerificationMeta('entityKey');
  @override
  late final GeneratedColumn<String> entityKey = GeneratedColumn<String>(
      'entity_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldNameMeta =
      const VerificationMeta('fieldName');
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
      'field_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localFilePathMeta =
      const VerificationMeta('localFilePath');
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
      'local_file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uploadedMeta =
      const VerificationMeta('uploaded');
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
      'uploaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("uploaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityType, entityKey, fieldName, localFilePath, uploaded];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_uploads';
  @override
  VerificationContext validateIntegrity(Insertable<PendingUpload> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_key')) {
      context.handle(_entityKeyMeta,
          entityKey.isAcceptableOrUnknown(data['entity_key']!, _entityKeyMeta));
    } else if (isInserting) {
      context.missing(_entityKeyMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(_fieldNameMeta,
          fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta));
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
          _localFilePathMeta,
          localFilePath.isAcceptableOrUnknown(
              data['local_file_path']!, _localFilePathMeta));
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('uploaded')) {
      context.handle(_uploadedMeta,
          uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingUpload map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingUpload(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_key'])!,
      fieldName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_name'])!,
      localFilePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_file_path'])!,
      uploaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}uploaded'])!,
    );
  }

  @override
  $PendingUploadsTable createAlias(String alias) {
    return $PendingUploadsTable(attachedDatabase, alias);
  }
}

class PendingUpload extends DataClass implements Insertable<PendingUpload> {
  final int id;
  final String entityType;
  final String entityKey;
  final String fieldName;
  final String localFilePath;
  final bool uploaded;
  const PendingUpload(
      {required this.id,
      required this.entityType,
      required this.entityKey,
      required this.fieldName,
      required this.localFilePath,
      required this.uploaded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_key'] = Variable<String>(entityKey);
    map['field_name'] = Variable<String>(fieldName);
    map['local_file_path'] = Variable<String>(localFilePath);
    map['uploaded'] = Variable<bool>(uploaded);
    return map;
  }

  PendingUploadsCompanion toCompanion(bool nullToAbsent) {
    return PendingUploadsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityKey: Value(entityKey),
      fieldName: Value(fieldName),
      localFilePath: Value(localFilePath),
      uploaded: Value(uploaded),
    );
  }

  factory PendingUpload.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingUpload(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityKey: serializer.fromJson<String>(json['entityKey']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityKey': serializer.toJson<String>(entityKey),
      'fieldName': serializer.toJson<String>(fieldName),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'uploaded': serializer.toJson<bool>(uploaded),
    };
  }

  PendingUpload copyWith(
          {int? id,
          String? entityType,
          String? entityKey,
          String? fieldName,
          String? localFilePath,
          bool? uploaded}) =>
      PendingUpload(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityKey: entityKey ?? this.entityKey,
        fieldName: fieldName ?? this.fieldName,
        localFilePath: localFilePath ?? this.localFilePath,
        uploaded: uploaded ?? this.uploaded,
      );
  PendingUpload copyWithCompanion(PendingUploadsCompanion data) {
    return PendingUpload(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityKey: data.entityKey.present ? data.entityKey.value : this.entityKey,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingUpload(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityKey: $entityKey, ')
          ..write('fieldName: $fieldName, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('uploaded: $uploaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, entityType, entityKey, fieldName, localFilePath, uploaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingUpload &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityKey == this.entityKey &&
          other.fieldName == this.fieldName &&
          other.localFilePath == this.localFilePath &&
          other.uploaded == this.uploaded);
}

class PendingUploadsCompanion extends UpdateCompanion<PendingUpload> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityKey;
  final Value<String> fieldName;
  final Value<String> localFilePath;
  final Value<bool> uploaded;
  const PendingUploadsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityKey = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.uploaded = const Value.absent(),
  });
  PendingUploadsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityKey,
    required String fieldName,
    required String localFilePath,
    this.uploaded = const Value.absent(),
  })  : entityType = Value(entityType),
        entityKey = Value(entityKey),
        fieldName = Value(fieldName),
        localFilePath = Value(localFilePath);
  static Insertable<PendingUpload> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityKey,
    Expression<String>? fieldName,
    Expression<String>? localFilePath,
    Expression<bool>? uploaded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityKey != null) 'entity_key': entityKey,
      if (fieldName != null) 'field_name': fieldName,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (uploaded != null) 'uploaded': uploaded,
    });
  }

  PendingUploadsCompanion copyWith(
      {Value<int>? id,
      Value<String>? entityType,
      Value<String>? entityKey,
      Value<String>? fieldName,
      Value<String>? localFilePath,
      Value<bool>? uploaded}) {
    return PendingUploadsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityKey: entityKey ?? this.entityKey,
      fieldName: fieldName ?? this.fieldName,
      localFilePath: localFilePath ?? this.localFilePath,
      uploaded: uploaded ?? this.uploaded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityKey.present) {
      map['entity_key'] = Variable<String>(entityKey.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingUploadsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityKey: $entityKey, ')
          ..write('fieldName: $fieldName, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('uploaded: $uploaded')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String key;
  final String value;
  const SyncMetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory SyncMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncMetaData copyWith({String? key, String? value}) => SyncMetaData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<SyncMetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SyncMetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $BooksTable books = $BooksTable(this);
  late final $BookIssuesTable bookIssues = $BookIssuesTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $GradesTable grades = $GradesTable(this);
  late final $SchoolBasicCacheTable schoolBasicCache =
      $SchoolBasicCacheTable(this);
  late final $GeneralLinksCacheTable generalLinksCache =
      $GeneralLinksCacheTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $PendingUploadsTable pendingUploads = $PendingUploadsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        students,
        books,
        bookIssues,
        activityLogs,
        grades,
        schoolBasicCache,
        generalLinksCache,
        syncOutbox,
        pendingUploads,
        syncMeta
      ];
}

typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  Value<int?> id,
  required String uuid,
  Value<String?> apaarId,
  Value<String?> penId,
  Value<String?> uniqueId,
  required String school,
  required String name,
  required String studentClass,
  required String rollno,
  required String gender,
  Value<String?> status,
  Value<String?> reason,
  required DateTime createdAt,
  required DateTime updatedAt,
  required int createdBy,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<int?> id,
  Value<String> uuid,
  Value<String?> apaarId,
  Value<String?> penId,
  Value<String?> uniqueId,
  Value<String> school,
  Value<String> name,
  Value<String> studentClass,
  Value<String> rollno,
  Value<String> gender,
  Value<String?> status,
  Value<String?> reason,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> createdBy,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apaarId => $composableBuilder(
      column: $table.apaarId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get penId => $composableBuilder(
      column: $table.penId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uniqueId => $composableBuilder(
      column: $table.uniqueId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get school => $composableBuilder(
      column: $table.school, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentClass => $composableBuilder(
      column: $table.studentClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rollno => $composableBuilder(
      column: $table.rollno, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apaarId => $composableBuilder(
      column: $table.apaarId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get penId => $composableBuilder(
      column: $table.penId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uniqueId => $composableBuilder(
      column: $table.uniqueId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get school => $composableBuilder(
      column: $table.school, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentClass => $composableBuilder(
      column: $table.studentClass,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rollno => $composableBuilder(
      column: $table.rollno, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get apaarId =>
      $composableBuilder(column: $table.apaarId, builder: (column) => column);

  GeneratedColumn<String> get penId =>
      $composableBuilder(column: $table.penId, builder: (column) => column);

  GeneratedColumn<String> get uniqueId =>
      $composableBuilder(column: $table.uniqueId, builder: (column) => column);

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get studentClass => $composableBuilder(
      column: $table.studentClass, builder: (column) => column);

  GeneratedColumn<String> get rollno =>
      $composableBuilder(column: $table.rollno, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$StudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()> {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String?> apaarId = const Value.absent(),
            Value<String?> penId = const Value.absent(),
            Value<String?> uniqueId = const Value.absent(),
            Value<String> school = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> studentClass = const Value.absent(),
            Value<String> rollno = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion(
            id: id,
            uuid: uuid,
            apaarId: apaarId,
            penId: penId,
            uniqueId: uniqueId,
            school: school,
            name: name,
            studentClass: studentClass,
            rollno: rollno,
            gender: gender,
            status: status,
            reason: reason,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            required String uuid,
            Value<String?> apaarId = const Value.absent(),
            Value<String?> penId = const Value.absent(),
            Value<String?> uniqueId = const Value.absent(),
            required String school,
            required String name,
            required String studentClass,
            required String rollno,
            required String gender,
            Value<String?> status = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            required int createdBy,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudentsCompanion.insert(
            id: id,
            uuid: uuid,
            apaarId: apaarId,
            penId: penId,
            uniqueId: uniqueId,
            school: school,
            name: name,
            studentClass: studentClass,
            rollno: rollno,
            gender: gender,
            status: status,
            reason: reason,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, BaseReferences<_$AppDatabase, $StudentsTable, Student>),
    Student,
    PrefetchHooks Function()>;
typedef $$BooksTableCreateCompanionBuilder = BooksCompanion Function({
  Value<int?> id,
  required String isbn,
  required String title,
  Value<String?> publisher,
  Value<String?> author,
  Value<String?> language,
  Value<String?> gener,
  Value<String?> level,
  Value<String?> coverPage,
  Value<String?> code,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$BooksTableUpdateCompanionBuilder = BooksCompanion Function({
  Value<int?> id,
  Value<String> isbn,
  Value<String> title,
  Value<String?> publisher,
  Value<String?> author,
  Value<String?> language,
  Value<String?> gener,
  Value<String?> level,
  Value<String?> coverPage,
  Value<String?> code,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get isbn => $composableBuilder(
      column: $table.isbn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publisher => $composableBuilder(
      column: $table.publisher, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gener => $composableBuilder(
      column: $table.gener, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverPage => $composableBuilder(
      column: $table.coverPage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get isbn => $composableBuilder(
      column: $table.isbn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publisher => $composableBuilder(
      column: $table.publisher, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gener => $composableBuilder(
      column: $table.gener, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverPage => $composableBuilder(
      column: $table.coverPage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get isbn =>
      $composableBuilder(column: $table.isbn, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get gener =>
      $composableBuilder(column: $table.gener, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get coverPage =>
      $composableBuilder(column: $table.coverPage, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$BooksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BooksTable,
    Book,
    $$BooksTableFilterComposer,
    $$BooksTableOrderingComposer,
    $$BooksTableAnnotationComposer,
    $$BooksTableCreateCompanionBuilder,
    $$BooksTableUpdateCompanionBuilder,
    (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
    Book,
    PrefetchHooks Function()> {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<String> isbn = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> publisher = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> gener = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<String?> coverPage = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BooksCompanion(
            id: id,
            isbn: isbn,
            title: title,
            publisher: publisher,
            author: author,
            language: language,
            gener: gener,
            level: level,
            coverPage: coverPage,
            code: code,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            required String isbn,
            required String title,
            Value<String?> publisher = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> gener = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<String?> coverPage = const Value.absent(),
            Value<String?> code = const Value.absent(),
            required DateTime updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BooksCompanion.insert(
            id: id,
            isbn: isbn,
            title: title,
            publisher: publisher,
            author: author,
            language: language,
            gener: gener,
            level: level,
            coverPage: coverPage,
            code: code,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BooksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BooksTable,
    Book,
    $$BooksTableFilterComposer,
    $$BooksTableOrderingComposer,
    $$BooksTableAnnotationComposer,
    $$BooksTableCreateCompanionBuilder,
    $$BooksTableUpdateCompanionBuilder,
    (Book, BaseReferences<_$AppDatabase, $BooksTable, Book>),
    Book,
    PrefetchHooks Function()>;
typedef $$BookIssuesTableCreateCompanionBuilder = BookIssuesCompanion Function({
  Value<int?> id,
  required String uniqid,
  required String uuid,
  required String bookIsbn,
  required String bookName,
  required String studentRollno,
  required String studentGrade,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> submittedAt,
  required int createdBy,
  Value<String> syncStatus,
  Value<int> localRowId,
});
typedef $$BookIssuesTableUpdateCompanionBuilder = BookIssuesCompanion Function({
  Value<int?> id,
  Value<String> uniqid,
  Value<String> uuid,
  Value<String> bookIsbn,
  Value<String> bookName,
  Value<String> studentRollno,
  Value<String> studentGrade,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> submittedAt,
  Value<int> createdBy,
  Value<String> syncStatus,
  Value<int> localRowId,
});

class $$BookIssuesTableFilterComposer
    extends Composer<_$AppDatabase, $BookIssuesTable> {
  $$BookIssuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uniqid => $composableBuilder(
      column: $table.uniqid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookIsbn => $composableBuilder(
      column: $table.bookIsbn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentRollno => $composableBuilder(
      column: $table.studentRollno, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studentGrade => $composableBuilder(
      column: $table.studentGrade, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localRowId => $composableBuilder(
      column: $table.localRowId, builder: (column) => ColumnFilters(column));
}

class $$BookIssuesTableOrderingComposer
    extends Composer<_$AppDatabase, $BookIssuesTable> {
  $$BookIssuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uniqid => $composableBuilder(
      column: $table.uniqid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookIsbn => $composableBuilder(
      column: $table.bookIsbn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentRollno => $composableBuilder(
      column: $table.studentRollno,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studentGrade => $composableBuilder(
      column: $table.studentGrade,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localRowId => $composableBuilder(
      column: $table.localRowId, builder: (column) => ColumnOrderings(column));
}

class $$BookIssuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookIssuesTable> {
  $$BookIssuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uniqid =>
      $composableBuilder(column: $table.uniqid, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get bookIsbn =>
      $composableBuilder(column: $table.bookIsbn, builder: (column) => column);

  GeneratedColumn<String> get bookName =>
      $composableBuilder(column: $table.bookName, builder: (column) => column);

  GeneratedColumn<String> get studentRollno => $composableBuilder(
      column: $table.studentRollno, builder: (column) => column);

  GeneratedColumn<String> get studentGrade => $composableBuilder(
      column: $table.studentGrade, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
      column: $table.submittedAt, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get localRowId => $composableBuilder(
      column: $table.localRowId, builder: (column) => column);
}

class $$BookIssuesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookIssuesTable,
    BookIssue,
    $$BookIssuesTableFilterComposer,
    $$BookIssuesTableOrderingComposer,
    $$BookIssuesTableAnnotationComposer,
    $$BookIssuesTableCreateCompanionBuilder,
    $$BookIssuesTableUpdateCompanionBuilder,
    (BookIssue, BaseReferences<_$AppDatabase, $BookIssuesTable, BookIssue>),
    BookIssue,
    PrefetchHooks Function()> {
  $$BookIssuesTableTableManager(_$AppDatabase db, $BookIssuesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookIssuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookIssuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookIssuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<String> uniqid = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> bookIsbn = const Value.absent(),
            Value<String> bookName = const Value.absent(),
            Value<String> studentRollno = const Value.absent(),
            Value<String> studentGrade = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> submittedAt = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> localRowId = const Value.absent(),
          }) =>
              BookIssuesCompanion(
            id: id,
            uniqid: uniqid,
            uuid: uuid,
            bookIsbn: bookIsbn,
            bookName: bookName,
            studentRollno: studentRollno,
            studentGrade: studentGrade,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            submittedAt: submittedAt,
            createdBy: createdBy,
            syncStatus: syncStatus,
            localRowId: localRowId,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            required String uniqid,
            required String uuid,
            required String bookIsbn,
            required String bookName,
            required String studentRollno,
            required String studentGrade,
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> submittedAt = const Value.absent(),
            required int createdBy,
            Value<String> syncStatus = const Value.absent(),
            Value<int> localRowId = const Value.absent(),
          }) =>
              BookIssuesCompanion.insert(
            id: id,
            uniqid: uniqid,
            uuid: uuid,
            bookIsbn: bookIsbn,
            bookName: bookName,
            studentRollno: studentRollno,
            studentGrade: studentGrade,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            submittedAt: submittedAt,
            createdBy: createdBy,
            syncStatus: syncStatus,
            localRowId: localRowId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookIssuesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookIssuesTable,
    BookIssue,
    $$BookIssuesTableFilterComposer,
    $$BookIssuesTableOrderingComposer,
    $$BookIssuesTableAnnotationComposer,
    $$BookIssuesTableCreateCompanionBuilder,
    $$BookIssuesTableUpdateCompanionBuilder,
    (BookIssue, BaseReferences<_$AppDatabase, $BookIssuesTable, BookIssue>),
    BookIssue,
    PrefetchHooks Function()>;
typedef $$ActivityLogsTableCreateCompanionBuilder = ActivityLogsCompanion
    Function({
  Value<int?> id,
  required String localId,
  required DateTime date,
  required String activityName,
  required String activityDescription,
  Value<String?> photo,
  required String bookDetails,
  required String participantsGrades,
  required int participantsNumber,
  required String conductedBy,
  required String school,
  required int createdBy,
  required DateTime createdAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$ActivityLogsTableUpdateCompanionBuilder = ActivityLogsCompanion
    Function({
  Value<int?> id,
  Value<String> localId,
  Value<DateTime> date,
  Value<String> activityName,
  Value<String> activityDescription,
  Value<String?> photo,
  Value<String> bookDetails,
  Value<String> participantsGrades,
  Value<int> participantsNumber,
  Value<String> conductedBy,
  Value<String> school,
  Value<int> createdBy,
  Value<DateTime> createdAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$ActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activityName => $composableBuilder(
      column: $table.activityName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activityDescription => $composableBuilder(
      column: $table.activityDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookDetails => $composableBuilder(
      column: $table.bookDetails, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get participantsGrades => $composableBuilder(
      column: $table.participantsGrades,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get participantsNumber => $composableBuilder(
      column: $table.participantsNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conductedBy => $composableBuilder(
      column: $table.conductedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get school => $composableBuilder(
      column: $table.school, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$ActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activityName => $composableBuilder(
      column: $table.activityName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activityDescription => $composableBuilder(
      column: $table.activityDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photo => $composableBuilder(
      column: $table.photo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookDetails => $composableBuilder(
      column: $table.bookDetails, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get participantsGrades => $composableBuilder(
      column: $table.participantsGrades,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get participantsNumber => $composableBuilder(
      column: $table.participantsNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conductedBy => $composableBuilder(
      column: $table.conductedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get school => $composableBuilder(
      column: $table.school, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$ActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get activityName => $composableBuilder(
      column: $table.activityName, builder: (column) => column);

  GeneratedColumn<String> get activityDescription => $composableBuilder(
      column: $table.activityDescription, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<String> get bookDetails => $composableBuilder(
      column: $table.bookDetails, builder: (column) => column);

  GeneratedColumn<String> get participantsGrades => $composableBuilder(
      column: $table.participantsGrades, builder: (column) => column);

  GeneratedColumn<int> get participantsNumber => $composableBuilder(
      column: $table.participantsNumber, builder: (column) => column);

  GeneratedColumn<String> get conductedBy => $composableBuilder(
      column: $table.conductedBy, builder: (column) => column);

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$ActivityLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActivityLogsTable,
    ActivityLog,
    $$ActivityLogsTableFilterComposer,
    $$ActivityLogsTableOrderingComposer,
    $$ActivityLogsTableAnnotationComposer,
    $$ActivityLogsTableCreateCompanionBuilder,
    $$ActivityLogsTableUpdateCompanionBuilder,
    (
      ActivityLog,
      BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>
    ),
    ActivityLog,
    PrefetchHooks Function()> {
  $$ActivityLogsTableTableManager(_$AppDatabase db, $ActivityLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            Value<String> localId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> activityName = const Value.absent(),
            Value<String> activityDescription = const Value.absent(),
            Value<String?> photo = const Value.absent(),
            Value<String> bookDetails = const Value.absent(),
            Value<String> participantsGrades = const Value.absent(),
            Value<int> participantsNumber = const Value.absent(),
            Value<String> conductedBy = const Value.absent(),
            Value<String> school = const Value.absent(),
            Value<int> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityLogsCompanion(
            id: id,
            localId: localId,
            date: date,
            activityName: activityName,
            activityDescription: activityDescription,
            photo: photo,
            bookDetails: bookDetails,
            participantsGrades: participantsGrades,
            participantsNumber: participantsNumber,
            conductedBy: conductedBy,
            school: school,
            createdBy: createdBy,
            createdAt: createdAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<int?> id = const Value.absent(),
            required String localId,
            required DateTime date,
            required String activityName,
            required String activityDescription,
            Value<String?> photo = const Value.absent(),
            required String bookDetails,
            required String participantsGrades,
            required int participantsNumber,
            required String conductedBy,
            required String school,
            required int createdBy,
            required DateTime createdAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityLogsCompanion.insert(
            id: id,
            localId: localId,
            date: date,
            activityName: activityName,
            activityDescription: activityDescription,
            photo: photo,
            bookDetails: bookDetails,
            participantsGrades: participantsGrades,
            participantsNumber: participantsNumber,
            conductedBy: conductedBy,
            school: school,
            createdBy: createdBy,
            createdAt: createdAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActivityLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActivityLogsTable,
    ActivityLog,
    $$ActivityLogsTableFilterComposer,
    $$ActivityLogsTableOrderingComposer,
    $$ActivityLogsTableAnnotationComposer,
    $$ActivityLogsTableCreateCompanionBuilder,
    $$ActivityLogsTableUpdateCompanionBuilder,
    (
      ActivityLog,
      BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>
    ),
    ActivityLog,
    PrefetchHooks Function()>;
typedef $$GradesTableCreateCompanionBuilder = GradesCompanion Function({
  required String grade,
  Value<int> rowid,
});
typedef $$GradesTableUpdateCompanionBuilder = GradesCompanion Function({
  Value<String> grade,
  Value<int> rowid,
});

class $$GradesTableFilterComposer
    extends Composer<_$AppDatabase, $GradesTable> {
  $$GradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnFilters(column));
}

class $$GradesTableOrderingComposer
    extends Composer<_$AppDatabase, $GradesTable> {
  $$GradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get grade => $composableBuilder(
      column: $table.grade, builder: (column) => ColumnOrderings(column));
}

class $$GradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GradesTable> {
  $$GradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);
}

class $$GradesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GradesTable,
    Grade,
    $$GradesTableFilterComposer,
    $$GradesTableOrderingComposer,
    $$GradesTableAnnotationComposer,
    $$GradesTableCreateCompanionBuilder,
    $$GradesTableUpdateCompanionBuilder,
    (Grade, BaseReferences<_$AppDatabase, $GradesTable, Grade>),
    Grade,
    PrefetchHooks Function()> {
  $$GradesTableTableManager(_$AppDatabase db, $GradesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> grade = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GradesCompanion(
            grade: grade,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String grade,
            Value<int> rowid = const Value.absent(),
          }) =>
              GradesCompanion.insert(
            grade: grade,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GradesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GradesTable,
    Grade,
    $$GradesTableFilterComposer,
    $$GradesTableOrderingComposer,
    $$GradesTableAnnotationComposer,
    $$GradesTableCreateCompanionBuilder,
    $$GradesTableUpdateCompanionBuilder,
    (Grade, BaseReferences<_$AppDatabase, $GradesTable, Grade>),
    Grade,
    PrefetchHooks Function()>;
typedef $$SchoolBasicCacheTableCreateCompanionBuilder
    = SchoolBasicCacheCompanion Function({
  required String schoolPid,
  required String state,
  required String distName,
  required String schoolCodeNew,
  required String schoolName,
  required String blockName,
  Value<int> rowid,
});
typedef $$SchoolBasicCacheTableUpdateCompanionBuilder
    = SchoolBasicCacheCompanion Function({
  Value<String> schoolPid,
  Value<String> state,
  Value<String> distName,
  Value<String> schoolCodeNew,
  Value<String> schoolName,
  Value<String> blockName,
  Value<int> rowid,
});

class $$SchoolBasicCacheTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolBasicCacheTable> {
  $$SchoolBasicCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get schoolPid => $composableBuilder(
      column: $table.schoolPid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get distName => $composableBuilder(
      column: $table.distName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get schoolCodeNew => $composableBuilder(
      column: $table.schoolCodeNew, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get schoolName => $composableBuilder(
      column: $table.schoolName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockName => $composableBuilder(
      column: $table.blockName, builder: (column) => ColumnFilters(column));
}

class $$SchoolBasicCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolBasicCacheTable> {
  $$SchoolBasicCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get schoolPid => $composableBuilder(
      column: $table.schoolPid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get distName => $composableBuilder(
      column: $table.distName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get schoolCodeNew => $composableBuilder(
      column: $table.schoolCodeNew,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get schoolName => $composableBuilder(
      column: $table.schoolName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockName => $composableBuilder(
      column: $table.blockName, builder: (column) => ColumnOrderings(column));
}

class $$SchoolBasicCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolBasicCacheTable> {
  $$SchoolBasicCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get schoolPid =>
      $composableBuilder(column: $table.schoolPid, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get distName =>
      $composableBuilder(column: $table.distName, builder: (column) => column);

  GeneratedColumn<String> get schoolCodeNew => $composableBuilder(
      column: $table.schoolCodeNew, builder: (column) => column);

  GeneratedColumn<String> get schoolName => $composableBuilder(
      column: $table.schoolName, builder: (column) => column);

  GeneratedColumn<String> get blockName =>
      $composableBuilder(column: $table.blockName, builder: (column) => column);
}

class $$SchoolBasicCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SchoolBasicCacheTable,
    SchoolBasicCacheData,
    $$SchoolBasicCacheTableFilterComposer,
    $$SchoolBasicCacheTableOrderingComposer,
    $$SchoolBasicCacheTableAnnotationComposer,
    $$SchoolBasicCacheTableCreateCompanionBuilder,
    $$SchoolBasicCacheTableUpdateCompanionBuilder,
    (
      SchoolBasicCacheData,
      BaseReferences<_$AppDatabase, $SchoolBasicCacheTable,
          SchoolBasicCacheData>
    ),
    SchoolBasicCacheData,
    PrefetchHooks Function()> {
  $$SchoolBasicCacheTableTableManager(
      _$AppDatabase db, $SchoolBasicCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolBasicCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolBasicCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolBasicCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> schoolPid = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String> distName = const Value.absent(),
            Value<String> schoolCodeNew = const Value.absent(),
            Value<String> schoolName = const Value.absent(),
            Value<String> blockName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SchoolBasicCacheCompanion(
            schoolPid: schoolPid,
            state: state,
            distName: distName,
            schoolCodeNew: schoolCodeNew,
            schoolName: schoolName,
            blockName: blockName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String schoolPid,
            required String state,
            required String distName,
            required String schoolCodeNew,
            required String schoolName,
            required String blockName,
            Value<int> rowid = const Value.absent(),
          }) =>
              SchoolBasicCacheCompanion.insert(
            schoolPid: schoolPid,
            state: state,
            distName: distName,
            schoolCodeNew: schoolCodeNew,
            schoolName: schoolName,
            blockName: blockName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SchoolBasicCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SchoolBasicCacheTable,
    SchoolBasicCacheData,
    $$SchoolBasicCacheTableFilterComposer,
    $$SchoolBasicCacheTableOrderingComposer,
    $$SchoolBasicCacheTableAnnotationComposer,
    $$SchoolBasicCacheTableCreateCompanionBuilder,
    $$SchoolBasicCacheTableUpdateCompanionBuilder,
    (
      SchoolBasicCacheData,
      BaseReferences<_$AppDatabase, $SchoolBasicCacheTable,
          SchoolBasicCacheData>
    ),
    SchoolBasicCacheData,
    PrefetchHooks Function()>;
typedef $$GeneralLinksCacheTableCreateCompanionBuilder
    = GeneralLinksCacheCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$GeneralLinksCacheTableUpdateCompanionBuilder
    = GeneralLinksCacheCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$GeneralLinksCacheTableFilterComposer
    extends Composer<_$AppDatabase, $GeneralLinksCacheTable> {
  $$GeneralLinksCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$GeneralLinksCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $GeneralLinksCacheTable> {
  $$GeneralLinksCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$GeneralLinksCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeneralLinksCacheTable> {
  $$GeneralLinksCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$GeneralLinksCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GeneralLinksCacheTable,
    GeneralLinksCacheData,
    $$GeneralLinksCacheTableFilterComposer,
    $$GeneralLinksCacheTableOrderingComposer,
    $$GeneralLinksCacheTableAnnotationComposer,
    $$GeneralLinksCacheTableCreateCompanionBuilder,
    $$GeneralLinksCacheTableUpdateCompanionBuilder,
    (
      GeneralLinksCacheData,
      BaseReferences<_$AppDatabase, $GeneralLinksCacheTable,
          GeneralLinksCacheData>
    ),
    GeneralLinksCacheData,
    PrefetchHooks Function()> {
  $$GeneralLinksCacheTableTableManager(
      _$AppDatabase db, $GeneralLinksCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneralLinksCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneralLinksCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeneralLinksCacheTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GeneralLinksCacheCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              GeneralLinksCacheCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GeneralLinksCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GeneralLinksCacheTable,
    GeneralLinksCacheData,
    $$GeneralLinksCacheTableFilterComposer,
    $$GeneralLinksCacheTableOrderingComposer,
    $$GeneralLinksCacheTableAnnotationComposer,
    $$GeneralLinksCacheTableCreateCompanionBuilder,
    $$GeneralLinksCacheTableUpdateCompanionBuilder,
    (
      GeneralLinksCacheData,
      BaseReferences<_$AppDatabase, $GeneralLinksCacheTable,
          GeneralLinksCacheData>
    ),
    GeneralLinksCacheData,
    PrefetchHooks Function()>;
typedef $$SyncOutboxTableCreateCompanionBuilder = SyncOutboxCompanion Function({
  Value<int> id,
  required String entityType,
  required String entityKey,
  required String operation,
  required String payloadJson,
  required DateTime createdAt,
  Value<int> retryCount,
  Value<String?> lastError,
});
typedef $$SyncOutboxTableUpdateCompanionBuilder = SyncOutboxCompanion Function({
  Value<int> id,
  Value<String> entityType,
  Value<String> entityKey,
  Value<String> operation,
  Value<String> payloadJson,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String?> lastError,
});

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityKey => $composableBuilder(
      column: $table.entityKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityKey => $composableBuilder(
      column: $table.entityKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityKey =>
      $composableBuilder(column: $table.entityKey, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$SyncOutboxTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()> {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityKey = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
          }) =>
              SyncOutboxCompanion(
            id: id,
            entityType: entityType,
            entityKey: entityKey,
            operation: operation,
            payloadJson: payloadJson,
            createdAt: createdAt,
            retryCount: retryCount,
            lastError: lastError,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required String entityKey,
            required String operation,
            required String payloadJson,
            required DateTime createdAt,
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
          }) =>
              SyncOutboxCompanion.insert(
            id: id,
            entityType: entityType,
            entityKey: entityKey,
            operation: operation,
            payloadJson: payloadJson,
            createdAt: createdAt,
            retryCount: retryCount,
            lastError: lastError,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncOutboxTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()>;
typedef $$PendingUploadsTableCreateCompanionBuilder = PendingUploadsCompanion
    Function({
  Value<int> id,
  required String entityType,
  required String entityKey,
  required String fieldName,
  required String localFilePath,
  Value<bool> uploaded,
});
typedef $$PendingUploadsTableUpdateCompanionBuilder = PendingUploadsCompanion
    Function({
  Value<int> id,
  Value<String> entityType,
  Value<String> entityKey,
  Value<String> fieldName,
  Value<String> localFilePath,
  Value<bool> uploaded,
});

class $$PendingUploadsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityKey => $composableBuilder(
      column: $table.entityKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fieldName => $composableBuilder(
      column: $table.fieldName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get uploaded => $composableBuilder(
      column: $table.uploaded, builder: (column) => ColumnFilters(column));
}

class $$PendingUploadsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityKey => $composableBuilder(
      column: $table.entityKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fieldName => $composableBuilder(
      column: $table.fieldName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get uploaded => $composableBuilder(
      column: $table.uploaded, builder: (column) => ColumnOrderings(column));
}

class $$PendingUploadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityKey =>
      $composableBuilder(column: $table.entityKey, builder: (column) => column);

  GeneratedColumn<String> get fieldName =>
      $composableBuilder(column: $table.fieldName, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath, builder: (column) => column);

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);
}

class $$PendingUploadsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingUploadsTable,
    PendingUpload,
    $$PendingUploadsTableFilterComposer,
    $$PendingUploadsTableOrderingComposer,
    $$PendingUploadsTableAnnotationComposer,
    $$PendingUploadsTableCreateCompanionBuilder,
    $$PendingUploadsTableUpdateCompanionBuilder,
    (
      PendingUpload,
      BaseReferences<_$AppDatabase, $PendingUploadsTable, PendingUpload>
    ),
    PendingUpload,
    PrefetchHooks Function()> {
  $$PendingUploadsTableTableManager(
      _$AppDatabase db, $PendingUploadsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingUploadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingUploadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingUploadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityKey = const Value.absent(),
            Value<String> fieldName = const Value.absent(),
            Value<String> localFilePath = const Value.absent(),
            Value<bool> uploaded = const Value.absent(),
          }) =>
              PendingUploadsCompanion(
            id: id,
            entityType: entityType,
            entityKey: entityKey,
            fieldName: fieldName,
            localFilePath: localFilePath,
            uploaded: uploaded,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entityType,
            required String entityKey,
            required String fieldName,
            required String localFilePath,
            Value<bool> uploaded = const Value.absent(),
          }) =>
              PendingUploadsCompanion.insert(
            id: id,
            entityType: entityType,
            entityKey: entityKey,
            fieldName: fieldName,
            localFilePath: localFilePath,
            uploaded: uploaded,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingUploadsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PendingUploadsTable,
    PendingUpload,
    $$PendingUploadsTableFilterComposer,
    $$PendingUploadsTableOrderingComposer,
    $$PendingUploadsTableAnnotationComposer,
    $$PendingUploadsTableCreateCompanionBuilder,
    $$PendingUploadsTableUpdateCompanionBuilder,
    (
      PendingUpload,
      BaseReferences<_$AppDatabase, $PendingUploadsTable, PendingUpload>
    ),
    PendingUpload,
    PrefetchHooks Function()>;
typedef $$SyncMetaTableCreateCompanionBuilder = SyncMetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SyncMetaTableUpdateCompanionBuilder = SyncMetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetaTable,
    SyncMetaData,
    $$SyncMetaTableFilterComposer,
    $$SyncMetaTableOrderingComposer,
    $$SyncMetaTableAnnotationComposer,
    $$SyncMetaTableCreateCompanionBuilder,
    $$SyncMetaTableUpdateCompanionBuilder,
    (SyncMetaData, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>),
    SyncMetaData,
    PrefetchHooks Function()> {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetaCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetaCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetaTable,
    SyncMetaData,
    $$SyncMetaTableFilterComposer,
    $$SyncMetaTableOrderingComposer,
    $$SyncMetaTableAnnotationComposer,
    $$SyncMetaTableCreateCompanionBuilder,
    $$SyncMetaTableUpdateCompanionBuilder,
    (SyncMetaData, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaData>),
    SyncMetaData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$BookIssuesTableTableManager get bookIssues =>
      $$BookIssuesTableTableManager(_db, _db.bookIssues);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
  $$GradesTableTableManager get grades =>
      $$GradesTableTableManager(_db, _db.grades);
  $$SchoolBasicCacheTableTableManager get schoolBasicCache =>
      $$SchoolBasicCacheTableTableManager(_db, _db.schoolBasicCache);
  $$GeneralLinksCacheTableTableManager get generalLinksCache =>
      $$GeneralLinksCacheTableTableManager(_db, _db.generalLinksCache);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$PendingUploadsTableTableManager get pendingUploads =>
      $$PendingUploadsTableTableManager(_db, _db.pendingUploads);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
}
