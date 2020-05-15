using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WinText : MonoBehaviour
{
    private Text text;

    // Start is called before the first frame update
    void Start()
    {
      text = GetComponent<Text>();

      // start text off as completely transparent black
      text.color = new Color(0, 0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
      if (Door.collided) {
        // reveal text only when the door is entered
  			text.color = new Color(0, 0, 0, 1);
  			text.text = "You Won!";
      }
    }
}
