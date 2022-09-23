using TMPro;
using UnityAtoms;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace UI
{
    public class MetersUiText : MonoBehaviour, IAtomListener<float>
    {
        [SerializeField] private FloatVariable _meters;
        [SerializeField] private RectTransform _submarineIcon;
        [SerializeField] private TextMeshProUGUI _text;

        private void OnEnable()
        {
            _meters.Changed.RegisterListener(this);
        }
        
        private void OnDisable()
        {
            _meters.Changed.UnregisterListener(this);
        }

        public void OnEventRaised(float value)
        {
            const float max = 100;
            var normalized = value / max;
            var anchor = new Vector2(0.5f, 1 - normalized);
            _submarineIcon.anchorMin = anchor;
            _submarineIcon.anchorMax = anchor;
            _text.text = $"{(int)value}";
        }
    }
}