using TMPro;
using UnityAtoms;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace UI
{
    public class MetersUiText : MonoBehaviour, IAtomListener<float>
    {
        [SerializeField] private FloatVariable _meters;
        [SerializeField] private TextMeshProUGUI _text;

        private void Start()
        {
            _meters.Changed.RegisterListener(this);
        }

        public void OnEventRaised(float value)
        {
            _text.text = $"{(int)value}";
        }
    }
}