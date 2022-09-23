using System;
using TMPro;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using UnityEngine.UI;

namespace UI
{
    public class HealthUi : MonoBehaviour
    {
        [SerializeField] private IntVariable _healthVariable;
        [SerializeField] private IntConstant _maxHealthVariable;
        [SerializeField] private Image _healthBar;
        [SerializeField] private TextMeshProUGUI _healthText;

        private void Start()
        {
            _healthVariable.Value = _maxHealthVariable.Value;
        }

        private void OnEnable()
        {
            _healthVariable.Changed.Register(OnHealthChanged);
        }
        
        private void OnDisable()
        {
            _healthVariable.Changed.Unregister(OnHealthChanged);
        }

        private void OnHealthChanged(int health)
        {
            var normalized = (float) _healthVariable.Value / _maxHealthVariable.Value;
            _healthBar.fillAmount = normalized;
            _healthText.text = $"{_healthVariable.Value}";
        }
    }
}