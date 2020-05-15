using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour
{

  public GameObject[] prefabs;

    // Start is called before the first frame update
    void Start()
    {

      // infinite gem spawning function, asynchronous
  		StartCoroutine(SpawnGem());
    }

    // Update is called once per frame
    void Update()
    {

    }

    IEnumerator SpawnGem() {
  		while (true) {

  			// instantiate one gem in this row
  			Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);

  			// pause 5-10 seconds until the next gem spawns
  			yield return new WaitForSeconds(Random.Range(5, 10));
  		}
  	}
}
