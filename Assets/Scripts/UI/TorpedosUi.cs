using System;
using TMPro;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace UI
{
    public class TorpedosUi : MonoBehaviour
    {
        [SerializeField] private IntVariable _torpedosVariable;
        [SerializeField] private IntConstant _initialValue;
        [SerializeField] private TextMeshProUGUI _torpedosText;

        private void Start()
        {
            _torpedosVariable.Value = _initialValue.Value;
        }

        private void OnEnable()
        {
            _torpedosVariable.Changed.Register(OnTorpedosChanged);
        }

        private void OnDisable()
        {
            _torpedosVariable.Changed.Unregister(OnTorpedosChanged);
        }

        private void OnTorpedosChanged(int torpedos)
        {
            _torpedosText.text = $"{_torpedosVariable.Value}";
        }
    }
}