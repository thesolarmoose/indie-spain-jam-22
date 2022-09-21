using Items;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace UI.Items
{
    public class ItemView : MonoBehaviour
    {
        [SerializeField] private Image _image;
        
        [SerializeField] private UnityEvent<Item> _onInitialized;

        public UnityEvent<Item> OnInitialized => _onInitialized;

        public void Initialize(Item item)
        {
            _image.sprite = item.Image;
            _onInitialized.Invoke(item);
        }
    }
}