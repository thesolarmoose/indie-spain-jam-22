using TMPro;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using UnityEngine.UI;

namespace UI
{
    public class GasUi : MonoBehaviour
    {
        [SerializeField] private FloatVariable _gasVariable;
        [SerializeField] private FloatConstant _maxGasVariable;
        [SerializeField] private Image _gasBar;
        [SerializeField] private TextMeshProUGUI _gasText;

        private void Start()
        {
            _gasVariable.Value = _maxGasVariable.Value;
        }

        private void OnEnable()
        {
            _gasVariable.Changed.Register(OnGasChanged);
        }
        
        private void OnDisable()
        {
            _gasVariable.Changed.Unregister(OnGasChanged);
        }

        private void OnGasChanged(float gas)
        {
            var gallons = (int) _gasVariable.Value;
            var currentGallonPercent = _gasVariable.Value - gallons;
            if (currentGallonPercent < Mathf.Epsilon)
            {
                currentGallonPercent = 1;
            }
            _gasBar.fillAmount = currentGallonPercent;
            _gasText.text = $"{gallons}/{_maxGasVariable.Value}";
        }
    }
}