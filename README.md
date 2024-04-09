## Flutter Hive
Hive is a lightweight and fast NoSQL database that can be used to store data in Flutter applications.

### Integration setup
- Step 1: Setup Hive
  To use Hive in Flutter, we need to add the following dependencies to the pubspec.yaml file:
  dependencies:
```
    hive: ^version
    hive_flutter: ^version
```
we also need to add hive_generator and build_runner to the dev dependencies:
```
    dev_dependencies:
    hive_generator: ^version
    build_runner: ^version
```

Next, we need to initialize Hive in the main() function of our Flutter application. We can do this by calling the Hive.initFlutter() method as shown below:

```
    void main() async {
    await Hive.initFlutter();
    runApp(const MyApp());
    }
```
-Step 2: Define Hive Type Adapters
Hive is a NoSQL database that stores data in key-value pairs. Where value can be of a different type such as int, string, list, or custom objects. To store custom objects in Hive, we need to define type adapters that tell Hive how to serialize and deserialize our objects. We can use the `hive_generator` package to generate type adapters for our custom objects automatically.
This means we will create a model class and store that entire modal in Hive. My model class is called as user_model.dart.
```
    class UserModel{
    final String userId;
    final String userName;
    final String email;
    
    const UserModel(this.userId, this.userName, this.email);
    }
```
It's a simple model class. let's make it compatible with Hive by tweaking it a little.

```
    import 'package:hive/hive.dart';
    part 'userModel.g.dart';
    
    @HiveType(typeId: 0) // This is model Class Type ID
    class UserModel extends HiveObject {
      @HiveField(0) //This is Field Index
      late String userId;
    
      @HiveField(1) //This is Field Index
      late String userName;
    
      @HiveField(2) //This is Field Index
      late String email;
    }
```

Annotate the model class with `@HiveType()`, so the generator knows this should be a TypeAdapter.
Annotate each field you want to save with `@HiveField(index)`, the index is an int and each index should appear once and you shouldn't change it after registering them.
In case you change the field name or its datatype or add a new field. You have to run the type adapter command again and re-run the app to reflect the changes in the app.
We can then generate the type adapters for this class by running the following command in the terminal:
    `dart run build_runner build`
This will generate a `user_model.g.dart` file that contains the type adapter for our `UserModel` class.
Finally, register the type adapter in your main function, just add it beneath your hive initialization.
```
    void main() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    runApp(const MyApp());
    }
```
- Step 3: Storing Data in Hive
  To store data in Hive, we need to open a Hive box. A box is similar to a table in a traditional SQL database and stores key-value pairs. We can open a box by calling the `Hive.openBox()` method and passing in the name of the box as a parameter. For example, we can open a box named `hive_users` as shown below:
  `Hive.openBox<UserModel>('hive_users');`
  We can open the same box multiple times, returning us the same box instance. However, it is good practice to open it once on app launch and get the box whenever we want to add/update/delete data from it. To get the user box, we can do the following:
  `Box<UserModel> userBox = Hive.box<UserModel>('hive_users');`
  And there are 2 ways to add data
  `box.add(value)` - just gives each value an index and auto increments it.
  `box.put('key', value)` - you have to specify the key for each value
  Now we can add data to it by creating a new instance of the `UserModel` class. and add it to Hive database using `add()` method
  For example, we can add a new user to the box as shown below:

```
   final user = UserModel()
   ..userId = uId
   ..userName = uName
   ..email = uEmail;
   final box = Boxes.getUsers();
   box.add(user);
```

- Step 4: Reading Data from Hive
  There are different ways to read data from your boxes:
  `box.get('key)` - get the value from a key.
  `box.getAt(index)` - get the value from an index created with `box.add()`.
  `box.values` - this returns an iterable containing all the items in the box.

- Step 5: Updating Data in Hive
  To update you can use `box.put('key', newValue)` to update that value, or `box.putAt(index, item)` which works like `getAt()`
  When we put in a new model with the same key, the old data gets updated.

- Step 6: Deleting Data from Hive
  Deleting items is similar to getting:
  `box.delete('key)` - delete by key
  `box.deleteAt(index)` - delete by index
  `box.deleteAll(keys)` - accepts an iterable of keys, and deletes all the keys given.
