import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _categoriesCollection = 'categories'; // Replace with your collection name

  // Fetch all categories
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection(_categoriesCollection).get();
      return snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList();
    } catch (error) {
      print("Error getting categories: $error");
      return [];
    }
  }

  // Add a new category
  Future<void> addCategory(Category category) async {
    try {
      DocumentReference docRef = _firestore.collection(_categoriesCollection).doc();
      category.id = docRef.id;
      await docRef.set(category.toJson());
    } catch (error) {
      print("Error adding category: $error");
    }
  }

  // Update an existing category
  Future<void> updateCategory(Category category) async {
    if (category.id == null) {
      print("Category ID is null. Cannot update category.");
      return;
    }
    try {
      await _firestore
          .collection(_categoriesCollection)
          .doc(category.id)
          .update(category.toJson());
    } catch (error) {
      print("Error updating category: $error");
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection(_categoriesCollection).doc(categoryId).delete();
    } catch (error) {
      print("Error deleting category: $error");
    }
  }
}
