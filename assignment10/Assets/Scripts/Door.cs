using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    public static bool collided = false;

    void OnTriggerEnter(Collider other){
      collided = true;
      other.transform.position = new Vector3(839, 56, -1595);
    }
}
