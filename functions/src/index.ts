import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const updateClinicRating = functions.firestore.document('ratings/{clinicId}/rating/{patientId}').onWrite(async (change, _) => await updateRating(change))

async function updateRating(change: functions.Change<functions.firestore.DocumentSnapshot>){
 const clinicRatingRef = change.after.ref.parent
 let numRatings = 0 
let total = 0
const docRefs = await clinicRatingRef.listDocuments()

for (const docRef of docRefs){
 const snapshot = await docRef.get()
 const data = snapshot.data()
 if (data != undefined){
  total += data.rating
  numRatings++
}
}
const average = total / numRatings 

const docId = change.after.ref.parent.parent!.id;

const clinicRef =  clinicRatingRef.parent!
console.log(` ${clinicRef.path} now has ${numRatings} ratings and an average of ${average}`)


admin.database().ref(`doctorInfo/clinicInfo/${docId}`).update({
 review: Math.round(average)
})

await clinicRef.update({
  avgRating: average,
  numRatings: numRatings
})
 
}