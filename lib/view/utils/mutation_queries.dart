class ConstantMutationQuaries {
  // INSERT_ONE
  static insertOne(entity) {
    return '''mutation insert_${entity}_one(\$object: ${entity}_insert_input!) { object: insert_${entity}_one(object: \$object) { id } } ''';
  }

  //INSERT_MANY
  static insertMany(entity) {
    return '''mutation insert_$entity(\$objects: [${entity}_insert_input!]!) { objects: insert_$entity(objects: \$objects) { affected_rows } } ''';
  }

  //UPSERT_ONE
  static upsertOne(entity, key, columns) {
    return '''mutation insert_${entity}_one(\$object: ${entity}_insert_input!) { object: insert_${entity}_one(object: \$object, on_conflict: {constraint: $key, update_columns: [$columns]}) { id } } ''';
  }

  //UPSERT_MANY
  static upsertMany(entity, key, columns) {
    return '''mutation insert_$entity(\$objects: [${entity}_insert_input!]!) { objects: insert_$entity(objects: \$objects, on_conflict: {constraint: $key, update_columns: [$columns]}) { affected_rows } }  ''';
  }

  //UPDATE_ONE
  static updateOne(entity) {
    return '''mutation update_${entity}_by_pk(\$id: uuid!, \$object: ${entity}_set_input) { object: update_${entity}_by_pk(pk_columns: {id : \$id}, _set: \$object) { id } } ''';
  }

  // UPDATE_ONE_STR_ID
  static updateOneStrId(entity) {
    return '''mutation update_${entity}_by_pk(\$id: String!, \$object: ${entity}_set_input) { object: update_${entity}_by_pk(pk_columns: {id : \$id}, _set: \$object) { id } } ''';
  }

  // UPDATE_MANY
  static updateMany(entity) {
    return '''mutation update_$entity(\$where: ${entity}_bool_exp!, \$object: ${entity}_set_input) { objects: update_$entity(where: \$where, _set: \$object) { affected_rows } } ''';
  }

  //DELETE_ONE
  static deleteOne(entity) {
    return '''mutation delete_${entity}_by_pk(\$id: uuid!) { object: delete_${entity}_by_pk(id : \$id) { id } } ''';
  }

  // DELETE_MANY
  static deleteMany(entity) {
    return '''mutation delete_$entity(\$where: ${entity}_bool_exp!) { object: delete_$entity(where : \$where) { affected_rows } } ''';
  }

  // INSERT_LOCATION
  static insertLocation() {
    return '''mutation insert_user_locations_one(\$object: user_locations_insert_input!) {
    object: insert_user_locations_one(object: \$object) {
      id
      active
      user_id
      lat
      lng
      country
      address_line_1
      address_line_2
      address_line_3
      city
      state
      postcode
      contact_name
      contact_number
      map_point
    }
   } ''';
  }

  // UPDATE_LOCATION
  static updateLocation() {
    return '''mutation update_user_locations_by_pk(
    \$id: uuid!
    \$object: user_locations_set_input!
  ) {
    object: update_user_locations_by_pk(
      pk_columns: { id: \$id }
      _set: \$object
    ) {
      id
      active
      user_id
      lat
      lng
      country
      address_line_1
      address_line_2
      address_line_3
      city
      state
      postcode
      map_point
    }
  } ''';
  }
}
