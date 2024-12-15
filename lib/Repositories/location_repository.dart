import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/location.dart';
import 'package:flutter/material.dart';

class LocationRepository {
  // Obtient la liste des locations depuis Firestore
  Future<List<Location>> getLocations() async {
    try {
      // Récupérer les documents de la collection 'locations'
      final snapshot = await FirebaseFirestore.instance.collection('locations').get();

      // Convertir chaque document en un objet Location
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Location.fromMap(data, doc.id); // Passer l'ID Firebase au modèle Location
      }).toList();
    } catch (e) {
      debugPrint('Error fetching locations: $e');
      return [];
    }
  }

  // Met à jour les locations locales en Firestore
  updateLocaltions(List<Location> locations) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (var location in locations) {
        final locationRef = FirebaseFirestore.instance.collection('locations').doc(location.id.toString());
        batch.set(locationRef, location.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error updating locations: $e');
    }
  }
  updateLocationsWithoutAdding() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final snapshot = await FirebaseFirestore.instance.collection('locations').get();
      for (var doc in snapshot.docs) {
        final location = Location.fromMap(doc.data(), doc.id);
        final locationRef = FirebaseFirestore.instance.collection('locations').doc(location.id.toString());
        batch.set(locationRef, location.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error updating locations: $e');
    }
  }

  // Ajoute une nouvelle location dans Firestore
  Future<void> addLocation(Location location) async {
    try {
      // Ajouter un document dans la collection 'locations'
      await FirebaseFirestore.instance.collection('locations').add(location.toMap());
    } catch (e) {
      debugPrint('Error adding location: $e');
    }
  }

  // Met à jour une location existante dans Firestore
  Future<void> updateLocation(Location location) async {
    try {
      debugPrint('REPO Updating location: ${location.id}');
      final locationRef = FirebaseFirestore.instance.collection('locations').doc(location.id.toString());
      await locationRef.update(location.toMap()); // Mettre à jour le document existant
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  // Supprime une location dans Firestore
  Future<void> deleteLocation(String id) async {
    try {
      debugPrint('REPO Deleting location with ID: $id');
      final locationRef = FirebaseFirestore.instance.collection('locations').doc(id.toString());
      await locationRef.delete(); // Supprimer le document de Firestore
    } catch (e) {
      debugPrint('Error deleting location: $e');
    }
  }
}
